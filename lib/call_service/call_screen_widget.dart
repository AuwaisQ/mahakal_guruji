import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mahakal/features/profile/controllers/profile_contrroller.dart';
import 'package:mahakal/call_service/call_action_button.dart';
import 'package:mahakal/call_service/call_service.dart';
import 'package:mahakal/data/datasource/remote/http/httpClient.dart';
import 'package:mahakal/main.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:sip_ua/sip_ua.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CallScreenWidget extends StatefulWidget {
  final Call? _call;
  bool? isAccepted = false;
  bool? isrejected = false;
  final String? requestId;
  final String? astrologerId;
  final String? charges;
  final String? userName;
  final String? userImageUrl;
  final String? callType;
  final bool? isCaller;
  CallScreenWidget(this._call, this.isAccepted, this.isrejected,
      {this.userName,
      this.astrologerId,
      this.charges,
      this.userImageUrl,
      this.callType,
      this.isCaller,
      this.requestId,
      super.key});

  @override
  State<CallScreenWidget> createState() => _MyCallScreenWidget();
}

class _MyCallScreenWidget extends State<CallScreenWidget>
    with WidgetsBindingObserver
    implements SipUaHelperListener {
  final SIPUAHelper? helper =
      Provider.of<CallServiceProvider>(Get.context!).helper;
  
  RTCVideoRenderer? _localRenderer;
  RTCVideoRenderer? _remoteRenderer;
  
  double? _localVideoHeight;
  double? _localVideoWidth;
  EdgeInsets _localVideoMargin = EdgeInsets.zero;
  
  MediaStream? _localStream;
  MediaStream? _remoteStream;
  bool _isTimerStarted = false;
  bool _showNumPad = false;
  final ValueNotifier<String> _timeLabel = ValueNotifier<String>('00:00');
  bool _billingInProgress = false;
  bool _audioMuted = false;
  bool _videoMuted = false;
  bool _speakerOn = false;
  bool _hold = false;
  bool _mirror = true;
  bool _callConfirmed = false;
  CallStateEnum _state = CallStateEnum.NONE;

  late String _transferTarget;
  Timer? _timer;
  Timer? _callWaitTimer;
  Timer? _debugTimer;

  // ✅ WALLET/BILLING FIELDS - RESTORED
  DateTime? callStartDateTime;
  DateTime? callEndDateTime;
  String paymentType = 'audio';
  double totalAmountPaid = 0.0;
  Map<String, dynamic>? callSummary;
  int? callRequestId;

  // cached request details for per-minute billing
  int? _astrologerId;
  int? _userId;

  bool get voiceOnly =>
      (widget._call?.voiceOnly ?? false) && !(call?.remote_has_video ?? false);

  String? get remoteIdentity => call?.remote_identity;
  Direction? get direction => call?.direction;
  Call? get call => widget._call ?? _currentCall;

  bool _localRendererInitialized = false;
  bool _remoteRendererInitialized = false;
  bool _initializing = false;

  String? get userName => widget.userName ?? '';
  String? get userImage => widget.userImageUrl ?? '';
  String? get requestId => widget.requestId ?? '';

  Call? _currentCall;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    if (!(voiceOnly)) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
      ]);
    }
    
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    if (_initializing) return;
    _initializing = true;
    
    try {
      await _initRenderers();
      helper?.addSipUaHelperListener(this);
      _checkCallStateOnResume();
      
      print('callType: ${widget.isCaller} ${widget.isAccepted} $call');
      print('Init Call Charges: ${widget.charges}/min');
      
      _startDebugTimer();
      
      if (!(widget.isCaller ?? false) && widget.isAccepted == true) {
        if (call != null) {
          await _handleAccept();
        } else {
          _waitForCallObject();
        }
      }
    } catch (e, stackTrace) {
      print('❌ Error initializing call screen: $e');
      print(stackTrace);
      if (mounted) {
        _showErrorAndPop('Failed to initialize call');
      }
    } finally {
      _initializing = false;
    }
  }

  void _startDebugTimer() {
    _debugTimer?.cancel();
    _debugTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      print('🔍 DEBUG Video State:');
      print('  Local: init=$_localRendererInitialized, stream=${_localStream != null}, '
            'renderVideo=${_localRenderer?.value.renderVideo}, '
            'size=${_localRenderer?.value.width}x${_localRenderer?.value.height}, '
            'textureId=${_localRenderer?.textureId}');
      print('  Remote: init=$_remoteRendererInitialized, stream=${_remoteStream != null}, '
            'renderVideo=${_remoteRenderer?.value.renderVideo}, '
            'size=${_remoteRenderer?.value.width}x${_remoteRenderer?.value.height}, '
            'textureId=${_remoteRenderer?.textureId}');
      
      if ((_localStream != null || _remoteStream != null) && mounted) {
        setState(() {});
      }
    });
  }

  void _showErrorAndPop(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  void _checkCallStateOnResume() {
    if (call == null ||
        call?.state == CallStateEnum.ENDED ||
        call?.state == CallStateEnum.FAILED) {
      Future.microtask(() {
        if (mounted) Navigator.of(context).pop();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _callWaitTimer?.cancel();
    _debugTimer?.cancel();
    _timer?.cancel();
    
    WakelockPlus.disable();
    print('🔓 Wake lock disabled');
    
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    if (call != null &&
        _state != CallStateEnum.ENDED &&
        _state != CallStateEnum.FAILED) {
      print('Widget disposed, ending call');
      call?.hangup({'status_code': 603});
      
      if (_localStream != null) {
        _localStream!.getTracks().forEach((track) => track.stop());
        _localStream!.dispose();
      }
    }
    super.dispose();
  }

  @override
  void deactivate() {
    helper?.removeSipUaHelperListener(this);
    _disposeRenderers();
    super.deactivate();
  }

  Future<void> _initRenderers() async {
    print('🎥 Initializing renderers...');
    
    _localRenderer = RTCVideoRenderer();
    _remoteRenderer = RTCVideoRenderer();
    
    await _localRenderer!.initialize();
    await _remoteRenderer!.initialize();
    
    _localRendererInitialized = true;
    _remoteRendererInitialized = true;
    
    _localRenderer?.addListener(_onRendererUpdate);
    _remoteRenderer?.addListener(_onRendererUpdate);
    
    print('✅ Renderers initialized with textureIds: ${_localRenderer?.textureId}, ${_remoteRenderer?.textureId}');
  }

  void _onRendererUpdate() {
    if (mounted) setState(() {});
  }

  void _disposeRenderers() {
    _localRenderer?.removeListener(_onRendererUpdate);
    _remoteRenderer?.removeListener(_onRendererUpdate);
    
    _localRenderer?.dispose();
    _remoteRenderer?.dispose();
    _localRenderer = null;
    _remoteRenderer = null;
    _localRendererInitialized = false;
    _remoteRendererInitialized = false;
  }

  void _waitForCallObject() {
    _callWaitTimer?.cancel();
    
    _callWaitTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (call != null) {
        print('Call object available, handling accept...');
        timer.cancel();
        _handleAccept();
      } else if (timer.tick >= 20) {
        print('Timeout waiting for call object');
        timer.cancel();
        if (mounted) Navigator.of(context).pop();
      }
    });
  }

  // ✅ RESTORED: Start timer with billing logic
  void _startTimer() async {
    _timer?.cancel();

    // Charge the first minute immediately before granting the first minute.
    final costPerMin = _parseChargePerMinute();
    final balanceNow = await _getWalletBalance();

    if (balanceNow < costPerMin) {
      Fluttertoast.showToast(msg: 'Insufficient balance. Call ended.');
      try {
        call?.hangup({'status_code': 603});
      } catch (e) {
        print('Error hanging up call after insufficient balance: $e');
      }
      await comepleteChat();
      if (mounted) Navigator.of(context).pop();
      return;
    }

    try {
      final resp = await _sendCallSummaryToApi(minuteCharge: costPerMin, incremental: true);
      if (resp != null) {
        totalAmountPaid += costPerMin;
        callSummary ??= <String, dynamic>{};
        callSummary!['total_amount_paid'] = totalAmountPaid;
        callSummary!['end_time'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      } else {
        // If backend didn't acknowledge, treat as failure to deduct
        Fluttertoast.showToast(msg: 'Payment failed. Call ended.');
        try {
          call?.hangup({'status_code': 603});
        } catch (e) {
          print('Error hanging up call after payment failure: $e');
        }
        await comepleteChat();
        if (mounted) Navigator.of(context).pop();
        return;
      }
    } catch (e) {
      debugPrint('Failed initial billing: $e');
      Fluttertoast.showToast(msg: 'Payment failed. Call ended.');
      try {
        call?.hangup({'status_code': 603});
      } catch (ex) {
        print('Error hanging up call after payment failure: $ex');
      }
      await comepleteChat();
      if (mounted) Navigator.of(context).pop();
      return;
    }

    // Start periodic checker which will attempt to deduct BEFORE granting each next minute
    DateTime nextBilling = DateTime.now().add(const Duration(minutes: 1));
    bool billingBusy = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final elapsed = DateTime.now().difference(callStartDateTime ?? DateTime.now());
      _timeLabel.value = [elapsed.inMinutes, elapsed.inSeconds]
          .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
          .join(':');

      if (billingBusy) return;
      if (DateTime.now().isBefore(nextBilling)) return;

      billingBusy = true;
      final cost = _parseChargePerMinute();
      final balance = await _getWalletBalance();

      if (balance < cost) {
        Fluttertoast.showToast(msg: 'Insufficient balance. Call ended.');
        timer.cancel();
        try {
          call?.hangup({'status_code': 603});
        } catch (e) {
          print('Error hanging up call after insufficient balance: $e');
        }
        await comepleteChat();
        if (mounted) Navigator.of(context).pop();
        billingBusy = false;
        return;
      }

      // Attempt to deduct the next minute first
      try {
        final r = await _sendCallSummaryToApi(minuteCharge: cost, incremental: true);
        if (r != null) {
          totalAmountPaid += cost;
          callSummary ??= <String, dynamic>{};
          callSummary!['total_amount_paid'] = totalAmountPaid;
          callSummary!['end_time'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
          nextBilling = nextBilling.add(const Duration(minutes: 1));
          if (mounted) setState(() {});
        } else {
          Fluttertoast.showToast(msg: 'Payment failed. Call ended.');
          timer.cancel();
          try {
            call?.hangup({'status_code': 603});
          } catch (e) {
            print('Error hanging up call after payment failure: $e');
          }
          await comepleteChat();
          if (mounted) Navigator.of(context).pop();
        }
      } catch (e) {
        debugPrint('Failed to send incremental billing update: $e');
      }

      billingBusy = false;
    });
  }
  
  // ✅ RESTORED: Fetch call request details
  Future<void> _fetchCallRequestDetails() async {
    if (callRequestId == null) return;
    try {
      final id = callRequestId!;
      final apiPath = '/api/call-requests/$id';
      final res = await HttpService().getApi(apiPath);
      if (res != null && res['success'] == true) {
        final data = res['callRequest'] ?? res;
        _astrologerId = (data['astrologer_id'] is num) ? (data['astrologer_id'] as num).toInt() : int.tryParse('${data['astrologer_id']}');
        _userId = (data['user_id'] is num) ? (data['user_id'] as num).toInt() : int.tryParse('${data['user_id']}');
        paymentType = data['call_type'] ?? paymentType;
        debugPrint('Fetched call request details: astro=$_astrologerId user=$_userId type=$paymentType');
      }
    } catch (e) {
      debugPrint('Failed to fetch call request details: $e');
    }
  }

  // ✅ RESTORED: Complete call and send summary
  Future<void> comepleteChat() async {
    if (!mounted) return;
    callEndDateTime = DateTime.now();

    String apiUrl = '${AppConstants.expressURI}/api/call-requests/$requestId/complete';
    print('call Complete URL -->$apiUrl');

    final response = await http.patch(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'start_time': callStartDateTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
        'end_time': callEndDateTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
      }),
    );
    print('call complete response ${response.body}');
    if (response.statusCode == 201 || response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print('Call Completed:-$responseBody');

      var astrologerId = responseBody['callRequest']['astrologer_id'];
      var userId = responseBody['callRequest']['user_id'];
      var callType = responseBody['callRequest']['call_type'];
      
      // Build and send final call summary
      await _buildAndSendFinalSummary(astrologerId, userId, callType);
      
      if (mounted) {
        setState(() {});
      }
    } else {
      print('Failed to make call request. Status code: ${response.statusCode}');
    }
  }

  // ✅ RESTORED: Build and send final summary
  Future<void> _buildAndSendFinalSummary(int astrologerId, int userId, String callType) async {
    final fmt = DateFormat('yyyy-MM-dd HH:mm:ss');
    final start = callStartDateTime ?? DateTime.now();
    final end = callEndDateTime ?? DateTime.now();
    final duration = end.difference(start);

    if (totalAmountPaid == 0.0) {
      final costPerMin = _parseChargePerMinute();
      final minutes = (duration.inSeconds / 60).ceil();
      totalAmountPaid = minutes * costPerMin;
    }
    
    final summary = {
      'user_id': userId,
      'astro_id': astrologerId,
      'payment_type': callType,
      'start_time': fmt.format(start),
      'end_time': fmt.format(end),
      'total_amount_paid': totalAmountPaid,
    };
    
    await _sendCallSummaryToApi(body: summary);
  }

  // ✅ RESTORED: Parse charge per minute
  double _parseChargePerMinute() {
    const fallback = 50.0;
    try {
      final charges = widget.charges;
      if (charges == null) return fallback;
      final s = charges.trim();
      if (s.isEmpty) return fallback;

      final match = RegExp(r"(\d+(?:\.\d+)?)").firstMatch(s);
      if (match != null && match.groupCount >= 1) {
        final numStr = match.group(1);
        if (numStr != null) {
          final parsed = double.tryParse(numStr);
          if (parsed != null) return parsed;
        }
      }
    } catch (e) {
      print('Error parsing charges: $e');
    }
    return fallback;
  }

  // ✅ RESTORED: Get wallet balance
  Future<double> _getWalletBalance() async {
    try {
      final userId = Provider.of<ProfileController>(context, listen: false).userID;
      final res = await HttpService().getApi('${AppConstants.fetchWalletAmount}$userId');
      if (res != null && res['success'] == true) {
        final wb = res['wallet_balance'];
        if (wb is num) return wb.toDouble();
        if (wb is String) return double.tryParse(wb) ?? 0.0;
      }
    } catch (e) {
      print('Error fetching wallet balance: $e');
    }
    return 0.0;
  }

  // ✅ RESTORED: Send call summary to API
  Future<dynamic> _sendCallSummaryToApi({Map<String, dynamic>? body, double? minuteCharge, bool incremental = false}) async {
    const url = AppConstants.astroWalletrack;
    try {
      final fmt = DateFormat('yyyy-MM-dd HH:mm:ss');
      final payload = (incremental && minuteCharge != null) ? {} : (body ?? {});
      
      if (incremental && minuteCharge != null) {
        int? astroId = _astrologerId;
        if (astroId == null && widget.astrologerId != null) {
          astroId = int.tryParse(widget.astrologerId!);
        }

        payload.addAll({
          'user_id': _userId ?? Provider.of<ProfileController>(context, listen: false).userID,
          'astro_id': astroId,
          'payment_type': paymentType,
          'req_id': (callRequestId != null) ? callRequestId.toString() : null,
          'start_time': fmt.format(DateTime.now().subtract(const Duration(minutes: 1))),
          'end_time': fmt.format(DateTime.now()),
          'total_amount_paid': minuteCharge,
        });
      }
      
      payload.removeWhere((k, v) => v == null);
      if (!payload.containsKey('astro_id')) {
        debugPrint('Warning: sending billing payload without astro_id: $payload');
      }

      debugPrint('Sending billing payload: $payload');

      final resp = await HttpService().postApi(url, payload);

      if (resp == null) {
        debugPrint('Failed to forward call summary: response was null');
      } else {
        debugPrint('Call summary forwarded: $resp');
      }

      return resp;
    } catch (e) {
      debugPrint('Error sending chat summary: $e');
      rethrow;
    }
  }

  void _enableWakeLock() {
    if (!voiceOnly) {
      WakelockPlus.enable();
      print('🔒 Wake lock enabled - screen will stay on during video call');
    }
  }

  void _disableWakeLock() {
    WakelockPlus.disable();
    print('🔓 Wake lock disabled');
  }

  @override
  void callStateChanged(Call call, CallState callState) {
    print('📞 Call State: ${callState.state}, originator: ${callState.originator}');
    if (!mounted) return;

    if (widget._call == null && _currentCall == null) {
      _currentCall = call;
    }

    if (callState.state == CallStateEnum.HOLD ||
        callState.state == CallStateEnum.UNHOLD) {
      _hold = callState.state == CallStateEnum.HOLD;
      setState(() {});
      return;
    }

    if (callState.state == CallStateEnum.STREAM) {
      print('🎬 STREAM event received - originator: ${callState.originator}, stream: ${callState.stream}');
      _handleStreams(callState);
      return;
    }

    if (callState.state == CallStateEnum.ACCEPTED || callState.state == CallStateEnum.CONFIRMED) {
      _enableWakeLock();
    }

    if (callState.state == CallStateEnum.ACCEPTED && !_isTimerStarted) {
      setState(() => _isTimerStarted = true);
      callStartDateTime = DateTime.now();
      callRequestId = int.tryParse(requestId ?? '');
      _fetchCallRequestDetails().whenComplete(() => _startTimer());
    }

    if (callState.state == CallStateEnum.MUTED) {
      if (callState.audio == true) _audioMuted = true;
      if (callState.video == true) _videoMuted = true;
      setState(() {});
      return;
    }

    if (callState.state == CallStateEnum.UNMUTED) {
      if (callState.audio == true) _audioMuted = false;
      if (callState.video == true) _videoMuted = false;
      setState(() {});
      return;
    }

    if (callState.state != CallStateEnum.STREAM) {
      _state = callState.state;
    }

    switch (callState.state) {
      case CallStateEnum.ENDED:
        print('Call ended naturally');
        _callWaitTimer?.cancel();
        _disableWakeLock();
        comepleteChat();
        _backToDialPad();
        break;
      case CallStateEnum.FAILED:
        print('Call failed');
        _callWaitTimer?.cancel();
        _disableWakeLock();
        _backToDialPad();
        break;
      case CallStateEnum.ACCEPTED:
        print('Testing Call Accepted');
        break;
      case CallStateEnum.CONFIRMED:
        print('Testing Call Confirmed');
        setState(() => _callConfirmed = true);
        break;
      default:
        break;
    }
  }

  void _handleStreams(CallState event) async {
    if (!mounted) return;
    
    final originator = event.originator;
    final stream = event.stream;
    
    print('📹 _handleStreams called - originator: $originator, stream: $stream');
    
    if (stream == null) {
      print('❌ Stream is null!');
      return;
    }

    if (originator == Originator.local) {
      print('🎥 Processing LOCAL stream');
      await _ensureLocalRendererReady();
      
      _localStream = stream;
      
      setState(() {
        _localRenderer!.srcObject = stream;
      });
      
      print('✅ Local stream assigned: ${_localStream?.id}, tracks: ${_localStream?.getTracks().length}');
      
      if (!kIsWeb && !WebRTC.platformIsDesktop) {
        final audioTracks = stream.getAudioTracks();
        if (audioTracks.isNotEmpty) {
          audioTracks.first.enableSpeakerphone(true);
        }
      }
      
      _resizeLocalVideo();
    }
    
    if (originator == Originator.remote) {
      print('🎥 Processing REMOTE stream');
      await _ensureRemoteRendererReady();
      
      _remoteStream = stream;
      
      setState(() {
        _remoteRenderer!.srcObject = stream;
      });
      
      print('✅ Remote stream assigned: ${_remoteStream?.id}, '
            'video tracks: ${_remoteStream?.getVideoTracks().length}, '
            'audio tracks: ${_remoteStream?.getAudioTracks().length}');
      
      _resizeLocalVideo();
      
      for (final delay in [100, 500, 1000, 2000]) {
        Future.delayed(Duration(milliseconds: delay), () {
          if (mounted) {
            print('🔔 Forcing rebuild at ${delay}ms');
            setState(() {});
          }
        });
      }
    }
  }

  Future<void> _ensureLocalRendererReady() async {
    if (_localRendererInitialized) return;
    if (_localRenderer == null) {
      _localRenderer = RTCVideoRenderer();
    }
    await _localRenderer!.initialize();
    _localRendererInitialized = true;
    _localRenderer?.addListener(_onRendererUpdate);
    print('✅ Local renderer ready with textureId: ${_localRenderer?.textureId}');
  }

  Future<void> _ensureRemoteRendererReady() async {
    if (_remoteRendererInitialized) return;
    if (_remoteRenderer == null) {
      _remoteRenderer = RTCVideoRenderer();
    }
    await _remoteRenderer!.initialize();
    _remoteRendererInitialized = true;
    _remoteRenderer?.addListener(_onRendererUpdate);
    print('✅ Remote renderer ready with textureId: ${_remoteRenderer?.textureId}');
  }

  void _resizeLocalVideo() {
    setState(() {
      if (_remoteStream != null) {
        _localVideoMargin = const EdgeInsets.only(top: 15, right: 15);
        _localVideoWidth = MediaQuery.of(context).size.width / 4;
        _localVideoHeight = MediaQuery.of(context).size.height / 4;
      } else {
        _localVideoMargin = EdgeInsets.zero;
        _localVideoWidth = MediaQuery.of(context).size.width;
        _localVideoHeight = MediaQuery.of(context).size.height;
      }
    });
  }

  Future<void> _handleAccept() async {
    if (call == null) {
      print('❌ Call is null');
      return;
    }
    await _handleAcceptWithCall(call!);
  }

  Future<void> _handleAcceptWithCall(Call call) async {
    await _ensureLocalRendererReady();
    await _ensureRemoteRendererReady();
    
    bool remoteHasVideo = call.remote_has_video ?? false;
    // Ensure paymentType reflects actual media type: video when remote provides video
    paymentType = remoteHasVideo ? 'video' : 'audio';
    print('📹 Remote has video: $remoteHasVideo');

    var mediaConstraints = <String, dynamic>{
      'audio': true,
      'video': remoteHasVideo
          ? {
              'mandatory': <String, dynamic>{
                'minWidth': '640',
                'minHeight': '480',
                'minFrameRate': '30',
              },
              'facingMode': 'user'
            }
          : false
    };

    MediaStream mediaStream;
    if (kIsWeb && remoteHasVideo) {
      mediaStream = await navigator.mediaDevices.getDisplayMedia(mediaConstraints);
      mediaConstraints['video'] = remoteHasVideo;
      MediaStream userStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      final audioTracks = userStream.getAudioTracks();
      if (audioTracks.isNotEmpty) {
        mediaStream.addTrack(audioTracks.first, addToNative: true);
      }
    } else {
      mediaStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    }
    
    print('✅ Media stream obtained: ${mediaStream.id}, answering call...');
    call.answer(helper!.buildCallOptions(!remoteHasVideo), mediaStream: mediaStream);
  }

  @override
  void transportStateChanged(TransportState state) {}
  @override
  void registrationStateChanged(RegistrationState state) {}

  void _cleanUp() {
    _localStream?.getTracks().forEach((track) => track.stop());
    _localStream?.dispose();
    _localStream = null;
  }

  void _backToDialPad() async {
    if (_isTimerStarted) {
      _timer?.cancel();
    }
    _cleanUp();
    if (mounted) Navigator.of(context).pop();
  }

  Widget _buildContent() {
    final stackWidgets = <Widget>[];

    stackWidgets.add(
      Container(
        color: Colors.black,
        width: double.infinity,
        height: double.infinity,
      ),
    );

    final bool hasLocalStream = _localStream != null;
    final bool hasRemoteStream = _remoteStream != null;
    
    print('🎬 _buildContent: hasLocalStream=$hasLocalStream, hasRemoteStream=$hasRemoteStream');
    print('   _localRendererInitialized=$_localRendererInitialized, _remoteRendererInitialized=$_remoteRendererInitialized');

    if (!voiceOnly && 
        _remoteRendererInitialized && 
        hasRemoteStream &&
        _remoteRenderer != null) {
      print('🎬 Building REMOTE video view');
      stackWidgets.add(
        Positioned.fill(
          child: Container(
            color: Colors.black,
            child: RTCVideoView(
              _remoteRenderer!,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              placeholderBuilder: (context) => Container(
                color: Colors.black,
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 16),
                        Text('Loading video...', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (!voiceOnly && 
        _localRendererInitialized && 
        hasLocalStream &&
        _localRenderer != null) {
      print('🎬 Building LOCAL video view (PIP)');
      stackWidgets.add(
        Positioned(
          top: _localVideoMargin.top * 3,
          left: _localVideoMargin.left,
          width: _localVideoWidth ?? MediaQuery.of(context).size.width / 4,
          height: _localVideoHeight ?? MediaQuery.of(context).size.height / 4,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: RTCVideoView(
              _localRenderer!,
              mirror: _mirror,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              placeholderBuilder: (context) => Container(
                color: Colors.grey[900],
                child: const Icon(Icons.videocam_off, color: Colors.white54),
              ),
            ),
          ),
        ),
      );
    }

    if (voiceOnly || !hasRemoteStream) {
      print('🎬 Showing overlay (voiceOnly=$voiceOnly, hasRemoteStream=$hasRemoteStream)');
      stackWidgets.add(_buildCallerInfoOverlay());
    }

    return Stack(
      fit: StackFit.expand,
      children: stackWidgets,
    );
  }

  Widget _buildCallerInfoOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black87,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 8),
              _buildCallerInfo(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallerInfo() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Hero(
            tag: 'caller_avatar_${requestId ?? "unknown"}',
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[800],
              ),
              child: ClipOval(
                child: userImage != null && userImage!.isNotEmpty
                    ? Image.network(
                        userImage!,
                        width: 160,
                        height: 160,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('Image load error: $error');
                          return Icon(Icons.person, size: 64, color: Colors.grey[400]);
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / 
                                    loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      )
                    : Icon(Icons.person, size: 64, color: Colors.grey[400]),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            userName?.isNotEmpty == true ? userName! : 'Unknown',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
            ),
          ),
          const SizedBox(height: 12),
          if (_isTimerStarted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ValueListenableBuilder<String>(
                valueListenable: _timeLabel,
                builder: (context, value, child) => Text(
                  value,
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _switchCamera() {
    if (_localStream != null && _localStream!.getVideoTracks().isNotEmpty) {
      Helper.switchCamera(_localStream!.getVideoTracks().first);
      setState(() => _mirror = !_mirror);
    }
  }

  void _muteAudio() {
    if (call == null) return;
    _audioMuted ? call!.unmute(true, false) : call!.mute(true, false);
  }

  void _muteVideo() {
    if (call == null) return;
    _videoMuted ? call!.unmute(false, true) : call!.mute(false, true);
  }

  void _handleHold() {
    if (call == null) return;
    _hold ? call!.unhold() : call!.hold();
  }

  void _toggleSpeaker() {
    if (_localStream != null && _localStream!.getAudioTracks().isNotEmpty) {
      _speakerOn = !_speakerOn;
      if (!kIsWeb) {
        _localStream!.getAudioTracks().first.enableSpeakerphone(_speakerOn);
      }
      setState(() {});
    }
  }

  void _handleHangup() async {
    print('state   $_state && $_isTimerStarted');
    if (_state != CallStateEnum.FAILED && _state != CallStateEnum.ENDED) {
      call?.hangup({'status_code': 603});
    }
    if (_isTimerStarted) {
      _timer?.cancel();
    }
  }
  
  Widget _buildActionButtons() {
    List<Widget> actions = [];
    print('state of button in call $_state');

    if (_state == CallStateEnum.ACCEPTED || _state == CallStateEnum.CONFIRMED) {
      actions = [
        if (voiceOnly)
          ActionButton(
            icon: _hold ? Icons.play_arrow : Icons.pause,
            checked: _hold,
            onPressed: () => _handleHold(),
          ),
        if (!voiceOnly)
          ActionButton(
            icon: _videoMuted ? Icons.videocam_off : Icons.videocam,
            onPressed: _muteVideo,
          ),
        if (!voiceOnly)
          ActionButton(
            icon: Icons.switch_video,
            onPressed: () => _switchCamera(),
          ),
        if (voiceOnly)
          ActionButton(
            icon: _speakerOn ? Icons.volume_up : Icons.volume_off,
            onPressed: _toggleSpeaker,
          ),
        ActionButton(
          icon: _audioMuted ? Icons.mic_off : Icons.mic,
          onPressed: _muteAudio,
        ),
        ActionButton(
          icon: Icons.call_end,
          fillColor: Colors.red,
          onPressed: _handleHangup,
        ),
      ];
    } else if (_state == CallStateEnum.PROGRESS || _state == CallStateEnum.CONNECTING) {
      actions = [
        ActionButton(
          icon: Icons.call_end,
          fillColor: Colors.red,
          onPressed: _handleHangup,
        ),
      ];
    } else if (_state == CallStateEnum.FAILED || _state == CallStateEnum.ENDED) {
      actions = [
        ActionButton(
          icon: Icons.call_end,
          fillColor: Colors.grey,
          onPressed: () => call?.hangup({'status_code': 603}),
        ),
      ];
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: actions,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: voiceOnly ? AppBar(
        centerTitle: true,
        backgroundColor: Colors.black87,
        automaticallyImplyLeading: false,
        title: const Text('Audio Call', style: TextStyle(color: Colors.white, fontSize: 16)),
      ) : null,
      body: Stack(
        children: [
          _buildContent(),
          if (!voiceOnly)
            Positioned(
              top: 40,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ValueListenableBuilder<String>(
                  valueListenable: _timeLabel,
                  builder: (context, value, child) => Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Courier',
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 350,
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: voiceOnly ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          child: _buildActionButtons(),
        ),
      ),
    );
  }

  @override
  void onNewReinvite(ReInvite event) {
    if (event.accept == null || event.reject == null) return;
    if (voiceOnly && (event.hasVideo ?? false)) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Upgrade to video?'),
            content: Text('$remoteIdentity is inviting you to video call'),
            alignment: Alignment.center,
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  event.reject!.call({'status_code': 607});
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  event.accept!.call({});
                  setState(() {
                    call!.voiceOnly = false;
                    // Upgrade to video -> update payment type
                    paymentType = 'video';
                    _resizeLocalVideo();
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void onNewMessage(SIPMessageRequest msg) {}
  @override
  void onNewNotify(Notify ntf) {}
}