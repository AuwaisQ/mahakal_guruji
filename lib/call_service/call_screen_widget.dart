import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  RTCVideoRenderer? _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer? _remoteRenderer = RTCVideoRenderer();
  double? _localVideoHeight;
  double? _localVideoWidth;
  EdgeInsetsGeometry? _localVideoMargin;
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
  late Timer _timer;

  // call summary fields
  DateTime? callStartDateTime;
  DateTime? callEndDateTime;
  String paymentType = 'audio';
  double totalAmountPaid = 0.0;
  Map<String, dynamic>? callSummary;
  int? callRequestId;

  // cached request details — filled when the call is accepted so per-minute
  // billing updates can include the relevant IDs for backend tracking
  int? _astrologerId;
  int? _userId;

  bool get voiceOnly =>
      (widget._call?.voiceOnly ?? false) && !(call?.remote_has_video ?? false);
  // bool get voiceOnly => widget._call?.voiceOnly ?? false;

  String? get remoteIdentity => call?.remote_identity;

  Direction? get direction => call?.direction;

  Call? get call => widget._call ?? _currentCall;

  bool _localRendererInitialized = false;
  bool _remoteRendererInitialized = false;

  String? get userName => widget.userName ?? '';
  String? get userImage => widget.userImageUrl ?? '';
  String? get requestId => widget.requestId ?? '';

  // Local call reference for when widget._call is null
  Call? _currentCall;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initRenderers();
    helper!.addSipUaHelperListener(this);
    _checkCallStateOnResume();
    print('callType: ${widget.isCaller} ${widget.isAccepted} $call');
    print('Init Call Charges: ${widget.charges}/min');
    // the screen on timeout.
    if (!(widget.isCaller ?? false) && widget.isAccepted == true) {
      if (call != null) {
        _handleAccept();
      } else {
        _waitForCallObject();
      }
    }
  }

  void _checkCallStateOnResume() {
    // If the call is already ended or failed, pop the screen
    if (call == null ||
        call?.state == CallStateEnum.ENDED ||
        call?.state == CallStateEnum.FAILED) {
      // End CallKit call if it's still active
      Future.microtask(() {
        if (mounted) Navigator.of(context).pop();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_isTimerStarted) {
      _timer.cancel();
    }
    if (call != null &&
        _state != CallStateEnum.ENDED &&
        _state != CallStateEnum.FAILED) {
      print('Widget disposed, ending call');
      call?.hangup({'status_code': 603});
      // we have to close the camera here  because sometimes when continuesly call then like 1 stiime video showing of receciverr but on next tiime not showing video of receiverr
      if (_localStream != null) {
        _localStream!.getTracks().forEach((track) => track.stop());
        _localStream!.dispose();
      }
    }
    super.dispose();
  }

  @override
  deactivate() {
    super.deactivate();
    helper!.removeSipUaHelperListener(this);
    _disposeRenderers();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      final duration = Duration(seconds: timer.tick);
      if (mounted) {
        _timeLabel.value = [duration.inMinutes, duration.inSeconds]
            .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
            .join(':');
      } else {
        _timer.cancel();
        return;
      }

      // Run billing checks in background every 60 seconds without
      // cancelling/restarting the visible timer. Prevent overlapping
      // checks with `_billingInProgress`.
      // Charge at the start of each minute (immediately after the first second
      // of that minute). Timer ticks start at 1, so use tick % 60 == 1 to
      // perform billing for the upcoming minute instead of waiting until the
      // minute has fully elapsed.
      if (timer.tick % 60 == 1) {
        if (_billingInProgress) return;
        _billingInProgress = true;
        try {
          final costPerMin = _parseChargePerMinute();
          final required = totalAmountPaid + costPerMin;
          final balance = await _getWalletBalance();

          if (balance >= required) {
            // Enough balance — charge automatically (add to total) and update summary
            totalAmountPaid += costPerMin;
            callSummary ??= <String, dynamic>{};
            callSummary!['total_amount_paid'] = totalAmountPaid;
            callSummary!['end_time'] =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

            // Send an incremental (per-minute) billing update to the backend.
            // This uses the same endpoint as final summary but sends only the
            // charge for the last minute so the backend can process/deduct it.
            try {
              await _sendCallSummaryToApi(minuteCharge: costPerMin, incremental: true);
            } catch (e) {
              debugPrint('Failed to send incremental billing update: $e');
            }
          } else {
            // Not enough balance. Attempt to place call on hold and prompt user.
            if (call != null) {
              try {
                call!.hold();
              } catch (e) {
                print('Error placing call on hold: $e');
              }
            }

            // Show a top-up prompt and automatically end the call after 60 seconds
            bool _sheetActive = true;
            Timer? _autoHangupTimer = Timer(const Duration(minutes: 1), () {
              if (!_sheetActive) return;
              // If the sheet is still open after 60 seconds, dismiss it with `false`
              if (mounted) {
                try {
                  Navigator.of(context).pop(false);
                } catch (e) {
                  // ignore: avoid_print
                  print('Auto hangup timer tried to pop sheet but failed: $e');
                }
              }
            });

            final resumed = await showModalBottomSheet<bool>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 16,
                    right: 16,
                    top: 20,
                  ),
                  child: StatefulBuilder(builder: (context, setState) {
                    bool checking = false;
                    double latestBalance = balance;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Insufficient Balance',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'You do not have enough balance to continue the call. Please top up your wallet. The call will end automatically in 60 seconds if you do not top up.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text('Required: ${required.toStringAsFixed(2)}'),
                        const SizedBox(height: 6),
                        Text('Current balance: ${latestBalance.toStringAsFixed(2)}'),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('End Call'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  setState(() => checking = true);
                                  latestBalance = await _getWalletBalance();
                                  setState(() => checking = false);
                                  if (latestBalance >= required) {
                                    Navigator.of(context).pop(true);
                                  }
                                },
                                child: const Text('Refresh Balance'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }),
                );
              },
            );

            // Sheet closed — cancel auto timer and mark sheet inactive
            _sheetActive = false;
            _autoHangupTimer.cancel();

            if (resumed == true) {
              // user topped up and balance is sufficient -> unhold
              if (call != null) {
                try {
                  call!.unhold();
                } catch (e) {
                  print('Error unholding call: $e');
                }
              }
            } else {
              // user chose to end call or dialog dismissed -> complete
              await comepleteChat();
            }
          }
        } finally {
          _billingInProgress = false;
        }
      }
    });
  }

  // NOTE: we intentionally do NOT post per-minute updates to the API. We
  // keep interim billing updates only in-memory, and send the final summary
  // via `comepleteChat()` when the call ends.

  void _initRenderers() async {
    if (_localRenderer != null) {
      await _localRenderer!.initialize();
      _localRendererInitialized = true;
    }
    if (_remoteRenderer != null) {
      await _remoteRenderer!.initialize();
      _remoteRendererInitialized = true;
    }
  }

  void _disposeRenderers() {
    if (_localRenderer != null) {
      _localRenderer!.dispose();
      _localRenderer = null;
    }
    if (_remoteRenderer != null) {
      _remoteRenderer!.dispose();
      _remoteRenderer = null;
    }
  }

  void _waitForCallObject() {
    // Check every 500ms for up to 10 seconds for the call object to become available
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (call != null) {
        print('Call object is now available, handling accept...');
        timer.cancel();
        _handleAccept();
      } else if (timer.tick >= 20) {
        // 10 seconds timeout
        print('Timeout waiting for call object, closing call screen');
        timer.cancel();
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void callStateChanged(Call call, CallState callState) {
    print('stattus of call ${callState.state}');
    if (!mounted) return;

    // Update the call reference if it was null before
    if (widget._call == null) {
      // This means the call object is now available
      print('Call object is now available, updating widget call reference');
      // Store the call reference locally for this widget
      _currentCall = call;

      // Retry getting user data if it failed before
      if (userName == '' && remoteIdentity != null) {}
    }

    if (callState.state == CallStateEnum.HOLD ||
        callState.state == CallStateEnum.UNHOLD) {
      _hold = callState.state == CallStateEnum.HOLD;
      setState(() {});
      return;
    }

    // Handle call acceptance when call object becomes available
    if (callState.state == CallStateEnum.CALL_INITIATION &&
        widget.isAccepted == true) {
      print('Call initiation detected for accepted call, handling accept...');
      _handleAcceptWithCall(call);
      return;
    }

    // Handle incoming call when call object becomes available
    if (callState.state == CallStateEnum.CALL_INITIATION &&
        widget.isAccepted == true &&
        _currentCall == null) {
      print('Incoming call detected, call object now available');
      _currentCall = call;
      // Don't call _handleAccept here as it should be handled by the CallController
    }

    if (callState.state == CallStateEnum.ACCEPTED && !_isTimerStarted) {
      setState(() {
        _isTimerStarted = true;
      });
      callStartDateTime = DateTime.now();
      callRequestId = int.tryParse(requestId ?? '') ?? null;
      // Ensure call request details are fetched before the first per-minute update
      _fetchCallRequestDetails().whenComplete(() => _startTimer());
    }

    if (callState.state == CallStateEnum.MUTED) {
      if (callState.audio!) _audioMuted = true;
      if (callState.video!) _videoMuted = true;
      setState(() {});
      return;
    }

    if (callState.state == CallStateEnum.UNMUTED) {
      if (callState.audio!) _audioMuted = false;
      if (callState.video!) _videoMuted = false;
      setState(() {});
      return;
    }

    if (callState.state != CallStateEnum.STREAM) {
      _state = callState.state;
    }

    switch (callState.state) {
      case CallStateEnum.STREAM:
        _handleStreams(callState);
        break;
      case CallStateEnum.ENDED:
        print('Call ended naturally, ending CallKit call');
        comepleteChat();
        _backToDialPad();
        break;
      case CallStateEnum.FAILED:
        print('Call failed, ending CallKit call');
        // if (direction == 'OUTGOING') {
        //   CallSoundHelper.playFailTone();
        //   Future.delayed(Duration(seconds: 1), () {
        //     CallSoundHelper.stop();
        //   });
        // }
        _backToDialPad();
        break;
      case CallStateEnum.UNMUTED:
      case CallStateEnum.MUTED:
      case CallStateEnum.CONNECTING:
      case CallStateEnum.PROGRESS:
        // CallSoundHelper.playRingbackTone();
        break;
      case CallStateEnum.ACCEPTED:
        print('Testing Call Accepted');
      case CallStateEnum.CONFIRMED:
        print('Testing Call Confirmed');
        // CallSoundHelper.stop();
        setState(() => _callConfirmed = true);
        break;
      case CallStateEnum.HOLD:
      case CallStateEnum.UNHOLD:
      case CallStateEnum.NONE:
      case CallStateEnum.CALL_INITIATION:
      case CallStateEnum.REFER:
        break;
    }
  }

  @override
  void transportStateChanged(TransportState state) {}

  @override
  void registrationStateChanged(RegistrationState state) {}

  void _cleanUp() {
    if (_localStream == null) return;
    _localStream?.getTracks().forEach((track) {
      track.stop();
    });
    _localStream!.dispose();
    _localStream = null;
  }

  void _backToDialPad() async {
    if (_isTimerStarted) {
      _timer.cancel();
    }
    print('call call data is ${call?.id}');

    _cleanUp();
    Navigator.of(context).pop();
  }

  void _handleStreams(CallState event) async {
    if (!mounted) return;
    MediaStream? stream = event.stream;
    print(
        'what is to handle Stream data ${event.originator} $_localRenderer && ${_localRenderer!.srcObject}');
    if (event.originator == 'local') {
      if (_localRenderer != null) {
        if (!_localRendererInitialized) {
          await _localRenderer!.initialize();
          _localRendererInitialized = true;
          setState(() {});
        }
        _localRenderer!.srcObject = stream;
      }

      if (!kIsWeb &&
          !WebRTC.platformIsDesktop &&
          event.stream?.getAudioTracks().isNotEmpty == true) {
        event.stream?.getAudioTracks().first.enableSpeakerphone(true);
      }
      _localStream = stream;
    }
    if (event.originator == 'remote') {
      print(
          'Remote stream event received: stream=$stream, renderer=$_remoteRenderer, initialized=$_remoteRendererInitialized');
      if (_remoteRenderer != null) {
        if (!_remoteRendererInitialized) {
          await _remoteRenderer!.initialize();
          _remoteRendererInitialized = true;
          setState(() {});
        }
        if (stream != null) {
          print(
              'Remote stream video tracks: \\${stream.getVideoTracks().length}');
        } else {
          print('Remote stream is null');
        }
        setState(() {
          _remoteRenderer!.srcObject = stream;
        });
      }
      _remoteStream = stream;
    }

    setState(() {
      _resizeLocalVideo();
    });
  }

  void _resizeLocalVideo() {
    _localVideoMargin = _remoteStream != null
        ? const EdgeInsets.only(top: 15, right: 15)
        : const EdgeInsets.all(0);
    _localVideoWidth = _remoteStream != null
        ? MediaQuery.of(context).size.width / 4
        : MediaQuery.of(context).size.width;
    _localVideoHeight = _remoteStream != null
        ? MediaQuery.of(context).size.height / 4
        : MediaQuery.of(context).size.height;
  }

  Future<bool> _walletAmount() async {
    // Check wallet balance for the logged-in user
    try {
      final userId = Provider.of<ProfileController>(context, listen: false).userID;
      final res = await HttpService().getApi('${AppConstants.fetchWalletAmount}$userId');
      if (res['success']) {
        if (res['wallet_balance'] == 0) {
          return false;
        } else {
          return true;
        }
      }
    } catch (e) {
      print('Error fetching wallet balance: $e');
    }
    return false;
  }

  // Future<Map<String, dynamic>> _buildCallSummary(int astrologerId, int userId, String callType) async {
  //   final fmt = DateFormat('yyyy-MM-dd HH:mm:ss');
  //   final start = callStartDateTime ?? DateTime.now();
  //   final end = callEndDateTime ?? DateTime.now();
  //   final duration = end.difference(start);
  //
  //   // Determine cost per minute from widget.charges (dynamic)
  //     if (totalAmountPaid == 0.0) {
  //       final costPerMin = _parseChargePerMinute();
  //       final minutes = (duration.inSeconds / 60).ceil();
  //       totalAmountPaid = minutes * costPerMin;
  //     }
  //   return {
  //     'user_id': userId,
  //     'astro_id': astrologerId,
  //     'payment_type': callType,
  //     'start_time': fmt.format(start),
  //     'end_time': fmt.format(end),
  //     'total_amount_paid': totalAmountPaid,
  //   };
  // }

  // Parse the per-minute charge from the incoming `widget.charges` string.
  // Supports values like "50", "50.0", "₹50/min", etc. Falls back to 50.0.
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

  // Get the wallet balance for current user. Returns 0.0 on error.
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

  // Fetch call request details from backend once the call is accepted, so
  // that per-minute billing payloads can include `astro_id` and `user_id`.
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

  /// Sends call summary to the backend. If [incremental] is true and
  /// [minuteCharge] is provided, this will send a per-minute billing update
  /// (start_time = now - 1 min, end_time = now) with `total_amount_paid` set
  /// to the minuteCharge. When sending incremental updates we include
  /// `req_id` so the backend can associate the charge.
  Future<dynamic> _sendCallSummaryToApi({Map<String, dynamic>? body, double? minuteCharge, bool incremental = false}) async {
    const url = AppConstants.astroWalletrack;
    try {
      final fmt = DateFormat('yyyy-MM-dd HH:mm:ss');
      // Build payload — for incremental (per-minute) updates attempt to
      // ensure we have an astro_id. If missing, try to resolve it from
      // `widget.astrologerId` or fetch the call request details.
      final payload = (incremental && minuteCharge != null) ? {} : (body ?? {});
      if (incremental && minuteCharge != null) {
        // prefer stored values but fall back to profile user id if unavailable
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
      // remove any null keys to keep payload clean
      payload.removeWhere((k, v) => v == null);
      if (!payload.containsKey('astro_id')) {
        debugPrint('Warning: sending billing payload without astro_id: $payload');
      }

      debugPrint('Sending billing payload: $payload');

      final resp = await HttpService().postApi(
        url,
        payload,
      );

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

  /// Allows external code/UI to set the payment details that will be included
  /// in the summary when the call completes.
  void setPaymentDetails({String? paymentType, double? totalAmount}) {
    if (paymentType != null) this.paymentType = paymentType;
    if (totalAmount != null) this.totalAmountPaid = totalAmount;
  }

  Future<void> comepleteChat() async {
    if (!mounted) return;
    // set call end time and compute summary
    callEndDateTime = DateTime.now();

    String apiUrl =
        '${AppConstants.expressURI}/api/call-requests/$requestId/complete';
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
      // callSummary = await _buildCallSummary(astrologerId, userId, callType);
      if (mounted) {
        setState(() {});
      }
      // await _sendCallSummaryToApi(body: callSummary!);
    } else {
      print('Failed to make call request. Status code: ${response.statusCode}');
    }
  }

  void _handleHangup() async {
    print('state   $_state && $_isTimerStarted');
    if (_state != CallStateEnum.FAILED && _state != CallStateEnum.ENDED) {
      call?.hangup({'status_code': 603});
    }
    if (_isTimerStarted) {
      _timer.cancel();
    }
  }

  // Method to handle system call controls (like swipe down on iOS)

  void _handleAccept() async {
    if (call == null) {
      print('Call object is null, cannot handle accept');
      return;
    }
    _handleAcceptWithCall(call!);
  }

  void _handleAcceptWithCall(Call call) async {
    bool remoteHasVideo = call.remote_has_video ?? false;
    print('remote has video or not $remoteHasVideo');
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
      mediaStream =
          await navigator.mediaDevices.getDisplayMedia(mediaConstraints);
      mediaConstraints['video'] = remoteHasVideo;
      MediaStream userStream =
          await navigator.mediaDevices.getUserMedia(mediaConstraints);
      final audioTracks = userStream.getAudioTracks();
      if (audioTracks.isNotEmpty) {
        mediaStream.addTrack(audioTracks.first, addToNative: true);
      }
    } else {
      mediaStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    }
    print('isCall answer successfully');
    call.answer(helper!.buildCallOptions(!remoteHasVideo),
        mediaStream: mediaStream);
  }

  void _switchCamera() {
    if (_localStream != null) {
      Helper.switchCamera(_localStream!.getVideoTracks()[0]);
      setState(() {
        _mirror = !_mirror;
      });
    }
  }

  void _muteAudio() {
    if (call == null) return;
    if (_audioMuted) {
      call!.unmute(true, false);
    } else {
      call!.mute(true, false);
    }
  }

  void _muteVideo() {
    if (call == null) return;
    if (_videoMuted) {
      call!.unmute(false, true);
    } else {
      call!.mute(false, true);
    }
  }

  void _handleHold() {
    if (call == null) return;
    if (_hold) {
      call!.unhold();
    } else {
      call!.hold();
    }
  }

  void _handleTransfer() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter target to transfer.'),
          content: TextField(
            onChanged: (String text) {
              setState(() {
                _transferTarget = text;
              });
            },
            decoration: const InputDecoration(
              hintText: 'URI or Username',
            ),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                if (call != null) {
                  call!.refer(_transferTarget);
                }
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleDtmf(String tone) {
    if (call == null) return;
    print('Dtmf tone => $tone');
    call!.sendDTMF(tone);
  }

  void _handleKeyPad() {
    setState(() {
      _showNumPad = !_showNumPad;
    });
  }

  void _handleVideoUpgrade() {
    if (call == null) return;
    if (voiceOnly) {
      setState(() {
        call!.voiceOnly = false;
      });
      helper!.renegotiate(
          call: call!,
          voiceOnly: false,
          done: (IncomingMessage? incomingMessage) {});
    } else {
      helper!.renegotiate(
          call: call!,
          voiceOnly: true,
          done: (IncomingMessage? incomingMessage) {});
    }
  }

  void _toggleSpeaker() {
    if (_localStream != null) {
      _speakerOn = !_speakerOn;
      if (!kIsWeb) {
        _localStream!.getAudioTracks()[0].enableSpeakerphone(_speakerOn);
      }
      setState(() {});
    }
  }

  List<Widget> _buildNumPad() {
    final labels = [
      [
        {'1': ''},
        {'2': 'abc'},
        {'3': 'def'}
      ],
      [
        {'4': 'ghi'},
        {'5': 'jkl'},
        {'6': 'mno'}
      ],
      [
        {'7': 'pqrs'},
        {'8': 'tuv'},
        {'9': 'wxyz'}
      ],
      [
        {'*': ''},
        {'0': '+'},
        {'#': ''}
      ],
    ];

    return labels
        .map((row) => Padding(
            padding: const EdgeInsets.all(3),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: row
                    .map((label) => ActionButton(
                          title: label.keys.first,
                          subTitle: label.values.first,
                          onPressed: () => _handleDtmf(label.keys.first),
                          number: true,
                        ))
                    .toList())))
        .toList();
  }

  Widget _buildActionButtons() {
    List<Widget> actions = [];

    print('state of button in call $_state');

    // Only show call actions when call is active
    if (_state == CallStateEnum.ACCEPTED || _state == CallStateEnum.CONFIRMED) {
      actions = [
        if (voiceOnly)
          ActionButton(
            icon: _hold ? Icons.play_arrow : Icons.pause,
            checked: _hold,
            onPressed: () => _handleHold(),
          ),
        // Video toggle
        if (!voiceOnly)
          ActionButton(
            icon: _videoMuted ? Icons.videocam : Icons.videocam_off,
            onPressed: _muteVideo,
          ),
        if (!voiceOnly)
          ActionButton(
            icon: Icons.switch_video,
            onPressed: () => _switchCamera(),
          ),

        // Speaker toggle
        if (voiceOnly)
          ActionButton(
            icon: _speakerOn ? Icons.volume_up : Icons.volume_off,
            onPressed: _toggleSpeaker,
          ),

        // Mute toggle
        ActionButton(
          icon: _audioMuted ? Icons.mic_off : Icons.mic,
          onPressed: _muteAudio,
        ),

        // Hang up
        ActionButton(
          icon: Icons.call_end,
          fillColor: Colors.red,
          onPressed: _handleHangup,
        ),
      ];
    } else if (_state == CallStateEnum.PROGRESS ||
        _state == CallStateEnum.CONNECTING) {
      actions = [
        ActionButton(
          icon: Icons.call_end,
          fillColor: Colors.red,
          onPressed: _handleHangup,
        ),
      ];
    } else if (_state == CallStateEnum.FAILED ||
        _state == CallStateEnum.ENDED) {
      actions = [
        ActionButton(
          icon: Icons.call_end,
          fillColor: Colors.grey,
          onPressed: () {
            call?.hangup({'status_code': 603});
          },
        ),
      ];
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: actions,
    );
  }

  Widget _buildContent() {
    Color? textColor = Theme.of(context).textTheme.bodyMedium?.color;
    final stackWidgets = <Widget>[];

    if (!voiceOnly && _remoteStream != null) {
      stackWidgets.add(
        Center(
          child: RTCVideoView(
            _remoteRenderer!,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          ),
        ),
      );
    }

    if (!voiceOnly && _localStream != null) {
      stackWidgets.add(
        AnimatedContainer(
          height: _localVideoHeight,
          width: _localVideoWidth,
          alignment: Alignment.topRight,
          duration: const Duration(milliseconds: 300),
          margin: _localVideoMargin,
          child: RTCVideoView(
            _localRenderer!,
            mirror: _mirror,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          ),
        ),
      );
    }
    if (voiceOnly || !_callConfirmed) {
      stackWidgets.addAll(
        [
          Positioned(
            top: MediaQuery.of(context).size.height / 8,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: userImage != null && userImage != ''
                        ? NetworkImage(userImage!)
                        : null,
                    backgroundColor: Colors.grey[300],
                    child: (userImage == '')
                        ? Icon(Icons.person, size: 48, color: Colors.grey[700])
                        : null,
                  ),
                  const SizedBox(height: 25),
                  Text(
                    userName != '' && userName != null ? userName! : 'unknown',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: ValueListenableBuilder<String>(
                        valueListenable: _timeLabel,
                        builder: (context, value, child) {
                          return _isTimerStarted
                              ? Text(
                                  _timeLabel.value,
                                  style: const TextStyle(
                                      fontSize: 40, color: Colors.white),
                                )
                              : Container();
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Stack(
      children: stackWidgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: !voiceOnly
          ? null
          : AppBar(
              centerTitle: true,
              backgroundColor: Colors.black87,
              automaticallyImplyLeading: false,
              title: Text(
                !voiceOnly ? 'Video Call' : 'Audio Call',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
      body: Stack(
        children: [
          _buildContent(),
          // Timer overlay for video calls (top-right)
          if (!voiceOnly)
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ValueListenableBuilder<String>(
                  valueListenable: _timeLabel,
                  builder: (context, value, child) {
                    return Text(
                      _timeLabel.value,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Courier',
                      ),
                    );
                  },
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
            color: !voiceOnly ? Colors.transparent : Colors.black,
            borderRadius: BorderRadius.circular(20)),
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          child: _buildActionButtons(),
        ),
      ),
    );
  }

  @override
  void onNewReinvite(ReInvite event) {
    if (event.accept == null) return;
    if (event.reject == null) return;
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
  void onNewMessage(SIPMessageRequest msg) {
    // NO OP
  }

  @override
  void onNewNotify(Notify ntf) {
    // NO OP
  }
}
