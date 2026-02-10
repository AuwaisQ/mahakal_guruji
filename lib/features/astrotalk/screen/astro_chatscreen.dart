import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mahakal/features/astrotalk/controller/astrotalk_controller.dart';
import 'package:mahakal/features/profile/controllers/profile_contrroller.dart';
import 'package:provider/provider.dart';
import '../../../data/datasource/remote/http/httpClient.dart';
import '../../../utill/app_constants.dart';
import 'package:mahakal/features/astrotalk/components/wallet_recharge_screen.dart';
import '../model/chat_model.dart';

class ChatState {
  static String? activeAstrologerId;
}

class ChatScreenView extends StatefulWidget {
  final String astrologerId;
  final String astrologerName;
  final String astrologerImage;
  final String userId;
  final int? chargePerMin;
  final bool? isConnect;
  ChatScreenView(
      {super.key,
      required this.astrologerId,
      required this.astrologerName,
      required this.astrologerImage,
      required this.userId,
      required this.chargePerMin,
      this.isConnect});

  @override
  State<ChatScreenView> createState() => _ChatScreenViewState();
}

class _ChatScreenViewState extends State<ChatScreenView> {
  var messageController = TextEditingController();
  bool isLoading = false;
  bool isConnected = false;
  bool isCompleted = false;
  bool isNewRequest = false;
  bool isRequested = false;
  List<Messages> messages = [];
  String userName = '';
  String userPhone = '';
  String userEmail = '';
  String userGender = '';
  String userDob = '';
  String userTob = '';
  String userPob = '';
  DateTime? chatStartDateTime;
  DateTime? chatEndDateTime;
  int? callRequestId;
  String paymentType = 'chat';
  double totalAmountPaid = 0.0;

  // initialize with a safe default to avoid LateInitializationError
  ValueNotifier<Duration> timerNotifier = ValueNotifier(Duration.zero);
  // _ticker is created when the timer is initialized; make it nullable and
  // guard disposal to avoid calling dispose on an uninitialized ticker.
  Ticker? _ticker;
  late final SocketController socketController;
  // handler for socket receive_message to allow unsubscribing on dispose
  void Function(dynamic)? _onReceiveMessageHandler;


  @override
  void initState() {
    super.initState();
    ChatState.activeAstrologerId = widget.astrologerId;
    socketController = Provider.of<SocketController>(context, listen: false);
    print('Socket Connection: ${socketController.isConnected}');
    if (socketController.isConnected == false) {
      socketController.initSocket(widget.userId);
    }
    userName = Provider.of<ProfileController>(context, listen: false).userNAME;
    userPhone =
        Provider.of<ProfileController>(context, listen: false).userPHONE;
    userEmail =
        Provider.of<ProfileController>(context, listen: false).userEMAIL;
    userGender =
        Provider.of<ProfileController>(context, listen: false).userGender;
    userDob = Provider.of<ProfileController>(context, listen: false).userDob;
    userTob = Provider.of<ProfileController>(context, listen: false).userTob;
    userPob = Provider.of<ProfileController>(context, listen: false).userPob;

    checkRequestStatus();

    // register a stable handler so it can be removed on dispose
    _onReceiveMessageHandler = (data) {
      print('Message Received-$data');
      msgReceived(data);
    };
    socketController.socketService.onReceiveMessage(_onReceiveMessageHandler!);
  }
  askToMakeChatRequest() async {
    bool proceed = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Start Chat'),
            content:
                const Text('Do you want to start a chat with the astrologer?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Start Chat'),
              ),
            ],
          ),
        ) ??
        false;

    if (proceed) {
      makeChatRequest();
    } else {
      fetchChatMessages(userA: widget.astrologerId, userB: widget.userId);
    }
  }

  void initializeTimer() {
    // Start elapsed timer (shows total chat duration) and schedule
    // per-minute billing checkpoints. The timer will not reset each minute
    // but will continue to increase while we bill in the background.
    chatStartDateTime ??= DateTime.now();
    timerNotifier = ValueNotifier<Duration>(Duration.zero);

    DateTime nextBilling = DateTime.now().add(const Duration(minutes: 1));
    bool billingInProgress = false;

    _ticker = Ticker((elapsed) async {
      if (!mounted) return;

      // Show total elapsed chat time
      final elapsedDuration = DateTime.now().difference(chatStartDateTime!);
      timerNotifier.value = elapsedDuration;

      // When we cross the billing checkpoint, verify wallet and either
      // schedule the next checkpoint or end the chat due to insufficient funds.
      if (!billingInProgress && (DateTime.now().isAtSameMomentAs(nextBilling) || DateTime.now().isAfter(nextBilling))) {
        billingInProgress = true;
        final nextMinuteCharge = widget.chargePerMin?.toDouble() ?? 50.0;
        final currentWalletBalance = await getWalletBalance();
        print('Billing check: balance=$currentWalletBalance, required=$nextMinuteCharge');

        // Defensively end the chat for zero or insufficient balance
        if (currentWalletBalance <= 0.0) {
          Fluttertoast.showToast(msg: 'Insufficient balance. Chat ended.');
          _ticker?.stop();
          if (callRequestId != null) {
            await comepleteChat(callRequestId!);
          } else {
            isConnected = false;
            if (mounted) setState(() {});
            if (mounted) Navigator.of(context).maybePop();
          }
        } else if (currentWalletBalance >= nextMinuteCharge) {
          // Enough balance: schedule next billing checkpoint (keep running)
          nextBilling = nextBilling.add(const Duration(minutes: 1));

          // Notify backend to deduct one minute's charge. Use the incremental
          // mode of _sendChatSummaryToApi so the backend updates every minute.
          if (callRequestId != null) {
            try {
              // call backend to charge one minute and capture the response
              final resp = await _sendChatSummaryToApi(callRequestId!, minuteCharge: nextMinuteCharge, incremental: true);
              if (resp != null) {
                // increment local counter for UI display
                totalAmountPaid += nextMinuteCharge;
                if (mounted) setState(() {});
              }
              // Optionally show a subtle toast notifying successful billing
              // Fluttertoast.showToast(msg: '1 minute billed: ₹$nextMinuteCharge');
            } catch (e) {
              print('Error sending incremental billing: $e');
            }
          } else {
            // If no callRequestId available, we still attempt to notify backend
            try {
              final resp = await _sendChatSummaryToApi(0, minuteCharge: nextMinuteCharge, incremental: true);
              if (resp != null) {
                totalAmountPaid += nextMinuteCharge;
                if (mounted) setState(() {});
              }
            } catch (e) {
              print('Error sending incremental billing without callRequestId: $e');
            }
          }
        } else {
          // Insufficient funds for the next full minute: stop and complete the chat
          Fluttertoast.showToast(msg: 'Insufficient balance. Chat ended.');
          _ticker?.stop();
          if (callRequestId != null) {
            await comepleteChat(callRequestId!);
          } else {
            isConnected = false;
            if (mounted) setState(() {});
            if (mounted) Navigator.of(context).maybePop();
          }
        }
        billingInProgress = false;
      }
    })..start();
  }

  Future<void> _showExitConfirmationBottomSheet() async {
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Leaving Chat',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'If you leave now, your active chat session may end.'
                ' Do you want to end the chat or stay connected?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        // Close the bottom sheet first
                        Navigator.of(context).pop();
                        // Perform end-chat logic
                        if (callRequestId != null) {
                          await comepleteChat(callRequestId!);
                        } else {
                          isConnected = false;
                          if (mounted) setState(() {});
                          Fluttertoast.showToast(msg: 'Chat ended');
                        }
                        // Pop the chat screen after completing the chat
                        if (mounted) Navigator.of(this.context).maybePop();
                      },
                      child: const Text('End Chat & Leave'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Simply close the bottom sheet to stay connected
                        Navigator.of(context).pop();
                      },
                      child: const Text('Stay Connected'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<void> comepleteChat(int id) async {
    String apiUrl = '${AppConstants.expressURI}/api/call-requests/$id/complete';

    // set the chat end time; do NOT build or send a final chat summary
    // because the backend is already receiving incremental per-minute updates.
    chatEndDateTime = DateTime.now();
    // if start time not set, fallback to now-minus-1min (safe fallback)
    chatStartDateTime ??= chatEndDateTime!.subtract(const Duration(minutes: 1));

    final response = await http.patch(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'start_time': chatStartDateTime!.toIso8601String(),
        'end_time': chatEndDateTime!.toIso8601String(),
      }),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print('chat Completed:-$responseBody');
      socketController.socketService.connectChat({
        'userId': widget.userId,
        'astrologerId': widget.astrologerId,
        'status': 'Completed',
      });
      isConnected = false;
      isCompleted = true;
      Fluttertoast.showToast(msg: 'Chat completed');
    //   Navigator.of(context).pushReplacement(
    //   CupertinoPageRoute(
    //     builder: (BuildContext context) => const BottomBar(pageIndex: 0),
    //   ),
    // );

      // No final summary is sent here — backend has been receiving per-minute
      // deductions during the session, so no end-of-chat billing POST is needed.
      if (mounted) setState(() {});
    } else {
      print('Failed to make call request. Status code: ${response.statusCode}');
    }
  }

  Future<void> connectChatFromCall(int id) async {
    String apiUrl = '${AppConstants.expressURI}/api/call-requests/$id/connect';

    final response = await http.patch(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print('chat Connected:-$responseBody');
      socketController.socketService.connectChat({
        'userId': widget.userId,
        'astrologerId': widget.astrologerId,
        'status': 'connected',
      });
      isConnected = true;
      Fluttertoast.showToast(msg: 'Astrologer Connected');
      // Check wallet before starting timer: if user has insufficient balance,
      // do not start the timer and end the chat session immediately.
      final minCharge = widget.chargePerMin?.toDouble() ?? 50.0;
      final initialBalance = await getWalletBalance();
      print('Initial wallet balance: $initialBalance, required: $minCharge');
      if (initialBalance >= minCharge) {
        chatStartDateTime = DateTime.now();
        initializeTimer();
      } else {
        Fluttertoast.showToast(msg: 'Insufficient balance to start chat. Please top up.');
        // End the chat on the server
        await comepleteChat(id);
      }

      callRequestId = id; // store id locally for later
      if (mounted) setState(() {});
    } else {
      print('Failed to make call request. Status code: ${response.statusCode}');
    }
  }

  Map<String, dynamic> _buildChatSummary() {
    final fmt = DateFormat('yyyy-MM-dd HH:mm:ss');
    final start = chatStartDateTime ?? DateTime.now();
    final end = chatEndDateTime ?? DateTime.now();
    final duration = end.difference(start);
    // Compute total amount for the session summary but DO NOT mutate
    // local state. Backend will be updated incrementally each minute.
    final costPerMin = widget.chargePerMin?.toDouble() ?? 50.0; // Use dynamic charge, fallback to 50
    final minutes = (duration.inSeconds / 60).ceil();
    final totalForSummary = minutes * costPerMin;

    print({
      'user_id': widget.userId,
      'astro_id': widget.astrologerId,
      'payment_type': paymentType,
      'start_time': fmt.format(start),
      'end_time': fmt.format(end),
      'total_amount_paid': totalForSummary,
    });

    return {
      'user_id': widget.userId,
      'astro_id': widget.astrologerId,
      'payment_type': paymentType,
      'start_time': fmt.format(start),
      'end_time': fmt.format(end),
      'total_amount_paid': totalForSummary,
    };
  }

  /// Sends chat summary to the backend. If [incremental] is true and
  /// [minuteCharge] is provided, the function will send a one-minute billing
  /// update (used to deduct money every minute). When used incrementally the
  /// function will NOT call Navigator.pop so it is safe to call repeatedly.
  Future<dynamic> _sendChatSummaryToApi(int id, {double? minuteCharge, bool incremental = false}) async {
    // Replace the endpoint with the correct route if required by your backend
    const url = AppConstants.astroWalletrack;
    try {
      final fmt = DateFormat('yyyy-MM-dd HH:mm:ss');

      final body = (incremental && minuteCharge != null)
          ? {
              'user_id': widget.userId,
              'astro_id': widget.astrologerId,
              'payment_type': paymentType,
              'req_id': id.toString(),
              'start_time': fmt.format(DateTime.now().subtract(const Duration(minutes: 1))),
              'end_time': fmt.format(DateTime.now()),
              'total_amount_paid': minuteCharge,
            }
          : (() {
              // Final summary payload - use the computed summary (no longer stored in state)
              final summary = Map<String, dynamic>.from(_buildChatSummary());
              summary['req_id'] = id.toString();
              return summary;
            })();

      debugPrint('Sending billing payload: $body');

      final resp = await HttpService().postApi(
        url,
        body,
      );

      // Only pop when this is the final summary call (i.e., not incremental)
      if (!incremental) {
        Navigator.pop(context);
      }

      if (resp == null) {
        debugPrint('Failed to forward chat summary: response was null');
      } else if (resp is Map<String, dynamic> || resp is List) {
        debugPrint('Chat summary forwarded: $resp');
      } else {
        debugPrint('Chat summary forwarded: $resp');
      }

      return resp;
    } catch (e) {
      debugPrint('Error sending chat summary: $e');
      return null;
    }
  }

  /// Allows external code/UI to set the payment details that will be included
  /// in the summary when the chat completes.
  void setPaymentDetails({String? paymentType, double? totalAmount}) {
    if (paymentType != null) this.paymentType = paymentType;
    if (totalAmount != null) this.totalAmountPaid = totalAmount;
    // don't call setState here unless UI depends on it. If UI should reflect
    // updated amount immediately, uncomment below:
    // setState(() {});
  }

  Future<void> checkRequestStatus() async {
    const String apiUrl = '${AppConstants.expressURI}/api/call-requests/check';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': widget.userId,
        'astrologer_id': widget.astrologerId,
        'call_type': 'chat',
      }),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      fetchChatMessages(userA: widget.astrologerId, userB: widget.userId);
      final responseBody = jsonDecode(response.body);
      print('Call Request Status: $responseBody');
      isRequested = responseBody['isRequested'];
      if (isRequested == false) {
        askToMakeChatRequest();
      } else if (isRequested == true) {
        makeChatRequest();
      }
      if (mounted) setState(() {});
    } else {
      print('Failed to make call request. Status code: ${response.statusCode}');
    }
  }

  Future<void> makeChatRequest() async {
    const String apiUrl = '${AppConstants.expressURI}/api/call-requests';

    // Pre-check wallet balance for at least 5 minutes before sending request
    final required = (widget.chargePerMin?.toDouble() ?? 50.0) * 5.0;
    final currentBalance = await getWalletBalance();
    print('Pre-request balance=$currentBalance required=$required');
    if (currentBalance < required) {
      // Prompt user to recharge
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => RechargeBottomSheet(
          userId: widget.userId,
          userEmail: userEmail,
          userName: userName,
          userPhone: userPhone,
        ),
      );
      return;
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': widget.userId,
        'astrologer_id': widget.astrologerId,
        'call_type': 'chat',
      }),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      fetchChatMessages(userA: widget.astrologerId, userB: widget.userId);
      final responseBody = jsonDecode(response.body);
      print('Call request successful: $responseBody');
      isConnected = responseBody['callRequest']['is_connected'];
      isCompleted = responseBody['callRequest']['completed'];
      var callReqId = jsonDecode(response.body)['callRequest']['id'];
      callRequestId = callReqId; // store call request id locally

      if(isConnected == true && isCompleted == false) {
        // Verify wallet balance before starting timer
        final minCharge = widget.chargePerMin?.toDouble() ?? 50.0;
        final initialBalance = await getWalletBalance();
        print('Initial wallet balance (post-request): $initialBalance, required: $minCharge');
        if (initialBalance >= minCharge) {
          chatStartDateTime = DateTime.now();
          initializeTimer();
        } else {
          Fluttertoast.showToast(msg: 'Insufficient balance to start chat. Please top up.');
          // End the chat gracefully
          if (callRequestId != null) {
            await comepleteChat(callRequestId!);
          } else {
            isConnected = false;
            if (mounted) setState(() {});
          }
        }
      }else if(isConnected == false || isCompleted == false){
        firstMessage();
      }

      if (widget.isConnect != null && widget.isConnect == true) {
        connectChatFromCall(callReqId);
        print('Astrologer Connected');
      }
      if (mounted) setState(() {});
    } else {
      print('Failed to make call request. Status code: ${response.statusCode}');
    }
  }

  void firstMessage() async {
    print('First Message Sent');
    final socketController =
        Provider.of<SocketController>(context, listen: false);

    socketController
      .sendChatMessage(
            to: widget.astrologerId,
            from: widget.userId,
            message:
                'Hi!,\nBelow are my details:\nName: $userName\nGender: $userGender\nDOB: $userDob\nTOB: $userTob\nPOB: $userPob')
        .then((val) {
      socketController.socketService.sendMessage(
        message:
            'Hi!,\nBelow are my details:\nName: $userName\nGender: $userGender\nDOB: $userDob\nTOB: $userTob\nPOB: $userPob',
        from: widget.userId, //UserId
        toUserId: widget.astrologerId, //AstrologerId
        msgFrom: 'user',
        datetime: DateTime.now().toIso8601String(),
      );
        // Update UI state only if the widget is still mounted. The
        // future callback may fire after the widget has been disposed.
        if (!mounted) return;
        messages.insert(
          0,
          Messages(
              from: widget.userId,
              to: widget.astrologerId,
              message:
                  'Hi!,\nBelow are my details:\nName: $userName\nGender: $userGender\nDOB: $userDob\nTOB: $userTob\nPOB: $userPob',
              datetime: DateTime.now().toIso8601String()));
      messageController.clear();
      if (mounted) setState(() {});
    });
  }

  // _onTick unused; timer logic uses Ticker directly inside initializeTimer

  Future<bool> walletAmount() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    var res = await HttpService()
        .getApi('${AppConstants.fetchWalletAmount}${widget.userId}');
    if (res['success']) {
      if (res['wallet_balance'] == 0) {
        print('Wallet amount is zero');
        if (mounted) {
          setState(() {
          isLoading = false;
        });
        }
        return false;
      } else {
        print('Wallet amount is-${res['wallet_balance']}');
        if (mounted) {
          setState(() {
          isLoading = false;
        });
        }
        return true;
      }
    }
    if (mounted) {
      setState(() {
      isLoading = false;
    });
    }
    return false;
  }

  Future<double> getWalletBalance() async {
    if (mounted) {
      setState(() => isLoading = true);
    }
    try {
      var res = await HttpService()
          .getApi('${AppConstants.fetchWalletAmount}${widget.userId}');
      if (res['success'] && res['wallet_balance'] != null) {
        return (res['wallet_balance'] as num).toDouble();
      }
    } catch (e) {
      print('Error getting wallet balance: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
    return 0.0;
  }

  msgReceived(data) {
    messages.insert(
        0,
        Messages(
            from: data['from'],
            to: data['to'] ?? widget.userId,
            message: data['message'],
            datetime: data['datetime']));
    if (mounted) {
      setState(() {});
    }
  }

  void fetchChatMessages({
    required String userA,
    required String userB,
    int chunk = 1,
  }) async {
    try {
      final url = Uri.parse(
          '${AppConstants.expressURI}/api/chat/get?userA=${widget.astrologerId}&userB=${widget.userId}&chunk=1');
      print('Fetching chat from: $url');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List decoded = json.decode(response.body)['messages'];
        debugPrint('$decoded}');
        messages.addAll(decoded.map((e) => Messages.fromJson(e)).toList());
        if (mounted) setState(() {});
      } else {
        throw Exception(
            'HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching chat messages: $e');
      rethrow; // or return []; if you want UI to handle it silently
    }
  }

  @override
  void dispose() {
    _ticker?.dispose();
    ChatState.activeAstrologerId = null;
    timerNotifier.dispose();
    // Unsubscribe from socket listener to avoid invoking callbacks on a
    // disposed widget, which can trigger setState after dispose.
    if (_onReceiveMessageHandler != null) {
      try {
        socketController.socketService.socket?.off('receive_message', _onReceiveMessageHandler);
      } catch (e) {
        // Fallback: remove all listeners for the event if listener-specific
        // removal isn't supported by the socket implementation.
        socketController.socketService.socket?.off('receive_message');
      }
      _onReceiveMessageHandler = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // If a chat is active (connected) and timer is still running, then
        // prompt the user whether they want to end the chat or continue.
        // Otherwise, allow the navigation to proceed.
        try {
          if (isConnected && timerNotifier.value > Duration.zero) {
            // Show the exit confirmation bottom sheet and let it perform the
            // necessary actions (either keep the chat alive or end it and pop
            // the chat screen). After the sheet returns, prevent the default
            // back navigation as the sheet handled it.
            await _showExitConfirmationBottomSheet();
            return false;
          }
        } catch (e) {
          // In case of any error, fallback to default behavior and allow pop.
          print('Error handling back navigation: $e');
        }
        return true;
      },
      child: Scaffold(
      // backgroundColor: Colors.yellow[100], // Match background from image
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                '${AppConstants.astrologersImages}${widget.astrologerImage}',
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.astrologerName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                ValueListenableBuilder<Duration>(
                  valueListenable: timerNotifier,
                  builder: (context, value, _) {
                    final minutes = value.inMinutes
                        .remainder(60)
                        .toString()
                        .padLeft(2, '0');
                    final seconds = value.inSeconds
                        .remainder(60)
                        .toString()
                        .padLeft(2, '0');
                    return Text(
                      '$minutes:$seconds mins',
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    );
                  },
                ),
                const Text('Chat in Progress',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.green, fontSize: 11)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'End Chat',
            onPressed: () {
              _showExitConfirmationBottomSheet();
            },
            icon: const Icon(
              CupertinoIcons.phone_solid,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.grey[200],
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final isMe = msg.from == widget.userId;
                        // final isMe = msg.from == "3";

                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            padding: const EdgeInsets.all(12),
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.75),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.yellow[200] : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(12),
                                topRight: const Radius.circular(12),
                                bottomLeft: Radius.circular(isMe ? 12 : 0),
                                bottomRight: Radius.circular(isMe ? 0 : 12),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg.message?.trim() ?? '',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  msg.datetime != null
                                      ? DateFormat('HH:mm dd-MM')
                                          .format(DateTime.parse(msg.datetime!))
                                      : '',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                  isConnected
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          color: Colors.white,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: messageController,
                                  decoration: InputDecoration(
                                    hintText: 'Type a Message',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Consumer<SocketController>(
                                  builder: (context, socketController, _) {
                                return CircleAvatar(
                                  backgroundColor: Colors.yellow[800],
                                  child: IconButton(
                                    icon: const Icon(Icons.send,
                                        color: Colors.white),
                                    onPressed: () {
                                      if (messageController.text.isEmpty) {
                                        Fluttertoast.showToast(
                                            msg: 'Type Something');
                                      } else {
                                        socketController
                                            .sendChatMessage(
                                                to: widget.astrologerId,
                                                from: widget.userId,
                                                message: messageController.text
                                                    .trim())
                                            .then((val) {
                                          socketController.socketService
                                              .sendMessage(
                                            message:
                                                messageController.text.trim(),
                                            from: widget.userId, //UserId
                                            toUserId: widget
                                                .astrologerId, //AstrologerId
                                            msgFrom: 'user',
                                            datetime: DateTime.now()
                                                .toIso8601String(),
                                          );
                                          messages.insert(
                                              0,
                                              Messages(
                                                  from: widget.userId,
                                                  to: widget.astrologerId,
                                                  message: messageController
                                                      .text
                                                      .trim(),
                                                  datetime: DateTime.now()
                                                      .toIso8601String()));
                                          messageController.clear();
                                          if (mounted) setState(() {});
                                        });
                                      }
                                    },
                                  ),
                                );
                              }),
                            ],
                          ),
                        )
                      : Container(
                          // padding: const EdgeInsets.symmetric(
                          //     horizontal: 12, vertical: 10),
                          color: Colors.transparent,
                          child: Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [Colors.white, Colors.yellow.shade50],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 32,
                                    backgroundImage: NetworkImage(
                                      '${AppConstants.astrologersImages}${widget.astrologerImage}',
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Waiting For ${widget.astrologerName}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        const Text(
                                          'Your Details have been shared with the Astrologer. Please wait while The Astrologer Connects Securely & Privately with You.',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                ],
              )),
          if (isLoading)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
  }
}