import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../features/profile/controllers/profile_contrroller.dart';
import '../main.dart';

class RazorpayPaymentService {
  late Razorpay _razorpay;

  // Callbacks to trigger from screen
  Function(PaymentSuccessResponse)? _onSuccessCallback;
  Function(PaymentFailureResponse)? _onFailureCallback;
  Function(ExternalWalletResponse)? _onExternalWalletCallback;

  RazorpayPaymentService() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout({
    required dynamic amount,
    required String description,
    String subscriptionId = '',
    String isSubscription = '',
    required String razorpayKey,
    Function(PaymentSuccessResponse)? onSuccess,
    Function(PaymentFailureResponse)? onFailure,
    Function(ExternalWalletResponse)? onExternalWallet,
  }) async {
    _onSuccessCallback = onSuccess;
    _onFailureCallback = onFailure;
    _onExternalWalletCallback = onExternalWallet;

    print('My Subscription Id Is:$subscriptionId');
    print('My Subscription Status Is:$isSubscription');
    final profile = Provider.of<ProfileController>(Get.context!, listen: false);

    var options = {
      'key': razorpayKey,

      // For one-time payment
      if (isSubscription != '2')
        'amount': (amount is int ? amount * 100 : (amount.toInt() * 100)),

      // For subscription payments
      if (isSubscription == '2') 'subscription_id': subscriptionId,

      'name': 'mahakal.com',
      'description': description,
      'payment_capture': 1,

      'timeout': 300,
      'prefill': {
        'contact': profile.userPHONE,
        'email': profile.userEMAIL,
      },
      'theme': {'color': '#FFA500', 'textColor': '#FFFFFF'},
      'external': {
        'wallets': ['paytm', 'phonepe', 'gpay']
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error opening Razorpay: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    try {
      Fluttertoast.showToast(
          msg: '✅ Payment Success',
          textColor: Colors.white,
          backgroundColor: Colors.green);
      FirebaseCrashlytics.instance.log(
        'Razorpay Payment Success | PaymentId: ${response.paymentId}',
      );
      _onSuccessCallback?.call(response);
    } catch (e,stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, reason: 'Error in _handlePaymentSuccess');
      debugPrint('Payment success callback error: $e');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    try {
      debugPrint('❌ Payment Failed: ${response.code} - ${response.message}');
      FirebaseCrashlytics.instance.log(
      'Razorpay Payment Failed | Code: ${response.code} | Message: ${response.message}',
    );
      Fluttertoast.showToast(
          msg: '❌ Payment Failed',
          textColor: Colors.white,
          backgroundColor: Colors.red);
      _onFailureCallback?.call(response);
    } catch (e,stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, reason: 'Error in _handlePaymentError');
      debugPrint('Payment failure callback error: $e');
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('💼 External Wallet Selected: ${response.walletName}');
    if (_onExternalWalletCallback != null) {
      _onExternalWalletCallback!(response);
    }
  }

  void dispose() {
    _razorpay.clear();
  }
}
