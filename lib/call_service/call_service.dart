// filename: call_service_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:mahakal/call_service/call_screen_widget.dart';
import 'package:mahakal/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_ua/sip_ua.dart';

class CallServiceProvider extends ChangeNotifier
    implements SipUaHelperListener {
  final SIPUAHelper _helper = SIPUAHelper();

  RegistrationState? _registerState;
  CallStateEnum? _callState;
  String? _callStatus;
  Call? _currentCall;

  bool isCallActive = false;
  bool isCaller = false;
  bool isConnecting = false;
  bool _callScreenNavigated = false; // Track if call screen was already navigated
  String _userName = '';
  String _userImage = '';
  String _requestId = '';
  String _charges = '';
  String _astrologerId = '';

  // Use the app-wide navigatorKey (defined in `lib/main.dart`) so call flows
  // can push/pop on the real app navigator. Previously this class created
  // its own key which was never attached to the widget tree causing
  // `callNavigatorKey.currentState` to be null.

  // Track if we actually pushed the call screen
  // bool _callScreenShown = false;

  String get userName => _userName;
  String get userImage => _userImage;
  String get requestId => _requestId;
  String get charges => _charges;
  String get astrologerId => _astrologerId;
  bool get callScreenNavigated => _callScreenNavigated;

  setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

   setAstrologerId(String id) {
    _astrologerId = id;
    notifyListeners();
  }


  setUserImage(String image) {
    _userImage = image;
    notifyListeners();
  }

  setRequestId(String id) {
    _requestId = id;
    notifyListeners();
  }

  setCharges(String charges) {
    _charges = charges;
    notifyListeners();
  }

  /// Reset the call screen navigation flag when call ends
  void resetCallScreenNavigated() {
    _callScreenNavigated = false;
    notifyListeners();
  }

  Call? get currentCall => _currentCall;
  RegistrationState? get registerState => _registerState;
  CallStateEnum? get callState => _callState;

  CallServiceProvider() {
    _helper.addSipUaHelperListener(this);
  }

  getSIPData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sipUser = prefs.getString('sipUser');
    String? sipPass = prefs.getString('sipPass');
    if (sipUser != null && sipPass != null) {
      connect(sipUser, sipPass);
    }
  }

  void connect(String sipUser, String sipPass) {
    print('📞 Calling Service Active $sipUser $sipPass');
    final settings = UaSettings()
      ..webSocketUrl = 'ws://89.116.32.44:8088/ws'
      ..uri = 'sip:$sipUser@89.116.32.44:5060'
      ..authorizationUser = sipUser
      ..password = sipPass
      ..displayName = 'Flutter User 1002'
      ..userAgent = 'Dart SIP Client v1.0.0'
      ..transportType = TransportType.WS
      ..iceServers = [
        {'urls': 'stun:stun.l.google.com:19302'},
        {'urls': 'stun:stun1.l.google.com:19302'},
      ];
    _helper.start(settings);
  }

  @override
  void registrationStateChanged(RegistrationState state) {
    print('✅ Registration State: ${state.state}');
    _registerState = state;
    notifyListeners();
  }

  @override
  void callStateChanged(Call call, CallState state) async {
    _callState = state.state;
    print('callStateChanged: ${state.state}');
    switch (state.state) {
      case CallStateEnum.CALL_INITIATION:
        isConnecting = true;
        isCallActive = true;
        _currentCall = call;
        final nav = navigatorKey.currentState;
        print('🚀 Navigating to Call Screen - $nav');
        if (nav != null) {
          // Mark that we've navigated to the call screen
          _callScreenNavigated = true;
          notifyListeners();
          // Ensure the navigator is properly assigned in the widget tree
          nav.push(MaterialPageRoute(
            builder: (_) => CallScreenWidget(
              call,
              true,
              false,
              requestId: requestId.isNotEmpty ? requestId : '-1',
              astrologerId: astrologerId.isNotEmpty ? astrologerId : '',
              userName: userName.isNotEmpty ? userName : 'John',
              userImageUrl: userImage.isNotEmpty ? userImage : '',
              charges: charges.isNotEmpty ? charges : '1',
              callType: 'audio',
              isCaller: false,
            ),
          ));
        } else {
          // Fallback: do not attempt to navigate via Get.context from provider
          print(
              '⚠️ Call navigator not ready or screen already shown. Skipping push.');
        }
        break;

      case CallStateEnum.ACCEPTED:
      case CallStateEnum.PROGRESS:
      case CallStateEnum.CONFIRMED:
        isConnecting = false;
        isCallActive = true;
        _currentCall = call;
        break;

      case CallStateEnum.FAILED:
        FlutterCallkitIncoming.endAllCalls();
        break;
      case CallStateEnum.ENDED:
        // Only pop if we actually showed the call screen
        isConnecting = false;
        isCallActive = false;
        isCaller = false;
        _currentCall = null;
        _callScreenNavigated = false; // Reset the flag when call ends
        final nav = navigatorKey.currentState;
        if (nav != null) {
          // nav.pushReplacement(MaterialPageRoute(
          //   builder: (_) => const BottomBar(pageIndex: 0),
          // ));
        }

        FlutterCallkitIncoming.endAllCalls();
        notifyListeners();
        break;

      default:
        if (state.state != CallStateEnum.CONNECTING &&
            state.state != CallStateEnum.CALL_INITIATION) {
          isConnecting = false;
        }
    }

    print('📲 Call State: ${state.state}');
    notifyListeners();
  }

  @override
  void onNewMessage(SIPMessageRequest msg) {
    print('✉️ New SIP Message: ${msg.request.toString()}');
  }

  @override
  void onNewNotify(Notify ntf) {
    print('🔔 Notify: ${ntf.toString()}');
  }

  @override
  void onNewReinvite(ReInvite event) {
    print('♻ Re-INVITE: ${event.toString()}');
  }

  @override
  void transportStateChanged(TransportState state) {
    print('🌐 Transport State: ${state.state}');
    // IMPORTANT: Do NOT navigate on DISCONNECTED/ERROR here.
    // If you must update UI, emit state and let the screen show a toast/snackbar.
  }

  SIPUAHelper get helper => _helper;

  /// Public API to mark that the call screen has been shown by external code.
  /// This prevents the provider from pushing a duplicate screen when the SIP
  /// call object becomes available and the provider's internal navigation
  /// logic runs.
  // void setCallScreenShown(bool shown) {
  //   _callScreenShown = shown;
  //   notifyListeners();
  // }

  @override
  void dispose() {
    _helper.removeSipUaHelperListener(this);
    _helper.stop();
    super.dispose();
  }
}
