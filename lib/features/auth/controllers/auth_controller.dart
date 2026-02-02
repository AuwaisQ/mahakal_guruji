import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mahakal/data/datasource/remote/dio/dio_client.dart';
import 'package:mahakal/features/auth/domain/models/login_model.dart';
import 'package:mahakal/features/auth/domain/models/register_model.dart';
import 'package:mahakal/data/model/api_response.dart';
import 'package:mahakal/data/model/error_response.dart';
import 'package:mahakal/data/model/response_model.dart';
import 'package:mahakal/features/auth/domain/models/social_login_model.dart';
import 'package:mahakal/features/auth/domain/services/auth_service_interface.dart';
import 'package:mahakal/features/auth/screens/auth_screen.dart';
import 'package:mahakal/helper/api_checker.dart';
import 'package:mahakal/localization/language_constrants.dart';
import 'package:mahakal/main.dart';
import 'package:mahakal/localization/controllers/localization_controller.dart';
import 'package:mahakal/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../profile/controllers/profile_contrroller.dart';

class AuthController with ChangeNotifier {
  final AuthServiceInterface authServiceInterface;
  AuthController({required this.authServiceInterface});

  DioClient? dioClient;
  bool _isLoading = false;
  bool _isRegisterLoading = false;
  bool _isRegisterScreen = false;
  bool? _isRemember = false;
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  String countryDialCode = '+91';
  String authToken = '';
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  var statusString = 'welcome';
  bool _OTPScreen = false;
  bool get OTPScreen => _OTPScreen;
  bool _isNumberDisable = true;
  bool get isNumberDisable => _isNumberDisable;
  var myVerificationId = '1';
  String get verifyResult => myVerificationId;
  double latitude = 23.179300;
  double longitude = 75.784912;
  String? country = "India";
  String? state = "Madhya Pradesh";
  String? city = "Ujjain";
  String? fullAddress = "Ujjain, M.P.";

  Future<void> signInPhoneNumber({
    required String myPhoneNumber,
    required BuildContext context,
  }) async {
    print('Phone-Number: $myPhoneNumber');

    // Validate the phone number using E.164 format
    final regex = RegExp(r'^\+[1-9]\d{7,14}$');

    if (!regex.hasMatch(myPhoneNumber)) {
      Fluttertoast.showToast(
        msg: "Invalid phone number format",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xff232323),
        textColor: Colors.white,
        fontSize: 18.0,
      );
      return;
    }

    try {
      _isNumberDisable = false;
      _isPhoneNumberVerificationButtonLoading = true;
      notifyListeners();

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: myPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          print("✅ Phone number automatically verified.");
          _isNumberDisable = false;
          // Optional: Sign in directly
          // await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          _isNumberDisable = true;
          print("❌ Verification failed: ${e.message}");
          print("❌ Stack Trace: ${e.stackTrace}");

          _isPhoneNumberVerificationButtonLoading = false;
          statusString = 'Error verifying your phone number';
          Fluttertoast.showToast(
            msg: e.message ?? "Phone verification failed",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
          );
          notifyListeners();
        },
        codeSent: (String verificationId, int? resendToken) {
          print("📩 OTP sent to $myPhoneNumber");
          print("📩 Verification ID: $verificationId");

          myVerificationId = verificationId;
          _OTPScreen = true;
          _isPhoneNumberVerificationButtonLoading = false;
          notifyListeners();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("⏳ Auto-retrieval timeout");
          myVerificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e, stack) {
      _isNumberDisable = true;
      print("🔥 Exception in signInPhoneNumber: $e");
      print(stack);
      _isPhoneNumberVerificationButtonLoading = false;
      Fluttertoast.showToast(
        msg: "Something went wrong: ${e.toString()}",
        backgroundColor: Colors.red,
      );
      notifyListeners();
    }
  }

  Future<void> verifyOtpAndSignIn(
    String verificationId,
    String smsCode,
    BuildContext context,
    String mobileNumber,
    Function callback,
  ) async {
    _isPhoneNumberVerificationButtonLoading = false;
    _isOTPLoading = true;
    _isNumberDisable = true;
    notifyListeners();

    try {
      // Create AuthCredential from the verification ID and OTP (smsCode)
      final AuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // Sign in with the generated credential
      final UserCredential userCredential =
          await firebaseAuth.signInWithCredential(authCredential);

      final bool isLogged = isLoggedIn(); // Your custom login check
      print("✅ Login value: $isLogged");

      // Call your post-login handler (e.g., send user data to API)
      await mobileVerification(mobileNumber, callback);
    } on FirebaseAuthException catch (e) {
      print('❌ FirebaseAuthException: ${e.message}');
      Fluttertoast.showToast(
        msg: "Invalid OTP: ${e.message ?? ''}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: const Color(0xff232323),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e, stack) {
      log('❌ Unexpected Error: $e');
      log(stack.toString());
      Fluttertoast.showToast(
        msg: "An unexpected error occurred.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: const Color(0xff232323),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      _isOTPLoading = false;
      notifyListeners();
    }
  }

  Future<void> mobileVerification(String phone, Function callback) async {
    var profileController =
        Provider.of<ProfileController>(Get.context!, listen: false);
    if (kDebugMode) {
      print('Verifying Mobile Triggered with - $phone');
    }
    final url = Uri.parse(AppConstants.baseUrl + AppConstants.mobileCheckURl);

    Map<String, String> body = {
      'phone': phone,
    };

    // Send the POST request
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      final responseData = json.decode(response.body);
      print('API Response-$responseData');
      if (responseData['status'] == false) {
        print('Response body: ${response.body}');
        _OTPScreen = false;
        _isRegisterScreen = true;
        notifyListeners();
      } else if (responseData['status'] == true &&
          responseData['block'] == false) {
        // Successful request
        clearGuestId();
        String token = responseData['token'];
        String message = responseData['message'];
        authToken = responseData['token'];
        print('userToken-$token');
        authServiceInterface.saveUserToken(token);
        await authServiceInterface.updateDeviceToken();
        await profileController.getUserInfo(Get.context!);
        callback(true, token, token, message);
        _isOTPLoading = false;
        _OTPScreen = false;
        notifyListeners();
      } else if (responseData['status'] == true &&
          responseData['block'] == true) {
        Navigator.pop(Get.context!);
        Navigator.of(Get.context!).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (context) => const AuthScreen()),
            (route) => false);
        Fluttertoast.showToast(
            msg: 'This Phone Number has been blocked!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 17.0);
      }
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Something went wrong Please Try Again!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xff232323),
          textColor: Colors.white,
          fontSize: 18.0);
      _OTPScreen = false;
      _isOTPLoading = false;
      log('Error occurred: $error');
    }
    notifyListeners();
  }

  Future<void> fetchCurrentLocation(BuildContext context) async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception(
              "Location permission denied. Please grant permission.");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Redirect user to app settings
        _showEnableLocationDialog(context);
        throw Exception(
            "Location permission is permanently denied. Enable it in settings.");
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double lat = position.latitude;
      double long = position.longitude;
      latitude = lat;
      longitude = long;
      print("Lat: $latitude | Long: $longitude");

      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        country = place.country ?? "Unknown";
        state = place.administrativeArea ?? "Unknown";
        city = place.locality ?? "Unknown";
        fullAddress = "${place.name}, $city, $state, $country";

        print("Address: $fullAddress");
      }
    } catch (e) {
      print("Failed to fetch location: $e");
    }
  }

// Function to show a dialog asking the user to enable location settings
  Future<bool> _showEnableLocationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Enable Location"),
              content: const Text(
                  "Your location services are disabled. Please enable them in settings."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                    Geolocator.openLocationSettings();
                  },
                  child: const Text("Open Settings"),
                ),
              ],
            );
          },
        ) ??
        false; // Default to false if the dialog is dismissed
  }

  Future<bool> userRegister(
      {required String phone,
      required String email,
      required String name,
      required Function callback}) async {
    if (kDebugMode) {
      print('User Registration Triggered');
    }
    print("PhoneNumber-$phone");
    _isRegisterLoading = true;
    notifyListeners();
    var profileController =
        Provider.of<ProfileController>(Get.context!, listen: false);
    final url = Uri.parse(AppConstants.baseUrl + AppConstants.userRegisterURl);
    print("Country-$country");
    print("State-$state");
    print("City-$city");
    print("FullAddress-$fullAddress");

    // Create the body of the request
    final body = {
      'phone': phone,
      'email': email,
      'name': name,
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "country": country,
      "state": state,
      "city": city,
      "address": fullAddress,
      "platform": Platform.isAndroid ? "Android" : "IOS",
    };

    print("API Body-$body");

    // Send the POST request
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      final responseData = json.decode(response.body);
      print("Register API Response- $responseData");
      if (responseData['status']) {
        // Successful request
        clearGuestId();
        String token = responseData['token'];
        String message = responseData['message'];
        authToken = responseData['token'];
        authServiceInterface.saveUserToken(token);
        await authServiceInterface.updateDeviceToken();
        await profileController.getUserInfo(Get.context!);
        callback(true, token, token, message);
        // Navigator.pushAndRemoveUntil(Get.context!, CupertinoPageRoute(builder: (_) => const BottomBar(pageIndex: 0)), (route) => false);
        _isOTPLoading = false;
        _OTPScreen = false;
        _isRegisterScreen = false;
        _isRegisterLoading = false;
        notifyListeners();
        return true;
      } else {
        _OTPScreen = false;
        _isRegisterScreen = false;
        _isOTPLoading = false;
        _isRegisterLoading = false;
        notifyListeners();
        // Handle the error
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        Fluttertoast.showToast(
            msg: "Something went wrong Please Try Again!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0xff232323),
            textColor: Colors.white,
            fontSize: 18.0);
        return false;
      }
    } catch (error) {
      _OTPScreen = false;
      _isOTPLoading = false;
      _isRegisterScreen = false;
      _isRegisterLoading = false;
      print('Error occurred: $error');
      Fluttertoast.showToast(
          msg: "Something went wrong\nPlease Try Again!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xff232323),
          textColor: Colors.white,
          fontSize: 18.0);
    }
    _isRegisterLoading = false;
    notifyListeners();
    return false;
  }

  void setCountryCode(String countryCode, {bool notify = true}) {
    countryDialCode = countryCode;
    if (notify) {
      notifyListeners();
    }
  }

  updateSelectedIndex(int index, {bool notify = true}) {
    _selectedIndex = index;
    if (notify) {
      notifyListeners();
    }
  }

  bool get isLoading => _isLoading;
  bool get isRegisterLoading => _isRegisterLoading;
  bool get isRegisterScreen => _isRegisterScreen;
  bool? get isRemember => _isRemember;

  void updateRemember() {
    _isRemember = !_isRemember!;
    notifyListeners();
  }

  Future<void> socialLogin(
      SocialLoginModel socialLogin, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await authServiceInterface.socialLogin(socialLogin.toJson());
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      _isLoading = false;
      Map map = apiResponse.response!.data;
      String? message = '', token = '', temporaryToken = '';
      try {
        message = map['error_message'];
        token = map['token'];
        temporaryToken = map['temporary_token'];
      } catch (e) {
        message = null;
        token = null;
        temporaryToken = null;
      }

      if (token != null) {
        authServiceInterface.saveUserToken(token);
        await authServiceInterface.updateDeviceToken();
        setCurrentLanguage(
            Provider.of<LocalizationController>(Get.context!, listen: false)
                    .getCurrentLanguage() ??
                'en');
      }
      callback(true, token, temporaryToken, message);
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future registration(RegisterModel register, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await authServiceInterface.registration(register.toJson());
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String? temporaryToken = '', token = '', message = '';
      try {
        message = map["message"];
        token = map["token"];
        temporaryToken = map["temporary_token"];
      } catch (e) {
        message = null;
        token = null;
        temporaryToken = null;
      }
      if (token != null && token.isNotEmpty) {
        authServiceInterface.saveUserToken(token);
        await authServiceInterface.updateDeviceToken();
      }
      callback(true, token, temporaryToken, message);
      notifyListeners();
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future logOut() async {
    ApiResponse apiResponse = await authServiceInterface.logout();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {}
  }

  Future<void> setCurrentLanguage(String currentLanguage) async {
    ApiResponse apiResponse =
        await authServiceInterface.setLanguageCode(currentLanguage);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {}
  }

  Future<void> login(LoginModel loginBody, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await authServiceInterface.login(loginBody.toJson());
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      clearGuestId();
      Map map = apiResponse.response!.data;
      String? temporaryToken = '', token = '', message = '';
      try {
        message = map["message"];
        token = map["token"];
        temporaryToken = map["temporary_token"];
      } catch (e) {
        message = null;
        token = null;
        temporaryToken = null;
      }
      if (token != null && token.isNotEmpty) {
        authServiceInterface.saveUserToken(token);
        await authServiceInterface.updateDeviceToken();
      }
      callback(true, token, temporaryToken, message);
      notifyListeners();
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> updateToken(BuildContext context) async {
    ApiResponse apiResponse = await authServiceInterface.updateDeviceToken();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
    } else {
      ApiChecker.checkApi(apiResponse);
    }
  }

  Future<ApiResponse> sendOtpToEmail(String email, String temporaryToken,
      {bool resendOtp = false}) async {
    _isPhoneNumberVerificationButtonLoading = true;
    notifyListeners();
    ApiResponse apiResponse;
    if (resendOtp) {
      apiResponse =
          await authServiceInterface.resendEmailOtp(email, temporaryToken);
    } else {
      apiResponse =
          await authServiceInterface.sendOtpToEmail(email, temporaryToken);
    }
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      resendTime = (apiResponse.response!.data["resend_time"]);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<ApiResponse> verifyEmail(String email, String token) async {
    _isPhoneNumberVerificationButtonLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await authServiceInterface.verifyEmail(email, _verificationCode, token);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      authServiceInterface.saveUserToken(apiResponse.response!.data['token']);
      await authServiceInterface.updateDeviceToken();
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  int resendTime = 0;

  Future<ResponseModel> sendOtpToPhone(String phone, String temporaryToken,
      {bool fromResend = false}) async {
    _isPhoneNumberVerificationButtonLoading = true;
    notifyListeners();
    ApiResponse apiResponse;
    if (fromResend) {
      apiResponse =
          await authServiceInterface.resendPhoneOtp(phone, temporaryToken);
    } else {
      apiResponse =
          await authServiceInterface.sendOtpToPhone(phone, temporaryToken);
    }
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      responseModel = ResponseModel(apiResponse.response!.data["token"], true);
      resendTime = (apiResponse.response!.data["resend_time"]);
    } else {
      String? errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        errorMessage = errorResponse.errors![0].message;
      }
      responseModel = ResponseModel(errorMessage, false);
    }
    notifyListeners();
    return responseModel;
  }

  Future<ApiResponse> verifyPhone(String phone, String token) async {
    _isPhoneNumberVerificationButtonLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await authServiceInterface.verifyPhone(phone, token, _verificationCode);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
    } else {
      _isPhoneNumberVerificationButtonLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<ApiResponse> verifyOtpForResetPassword(String phone) async {
    _isPhoneNumberVerificationButtonLoading = true;
    notifyListeners();

    ApiResponse apiResponse =
        await authServiceInterface.verifyOtp(phone, _verificationCode);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
    } else {
      _isPhoneNumberVerificationButtonLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<ApiResponse> resetPassword(String identity, String otp,
      String password, String confirmPassword) async {
    _isPhoneNumberVerificationButtonLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authServiceInterface.resetPassword(
        identity, otp, password, confirmPassword);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      showCustomSnackBar(
          getTranslated('password_reset_successfully', Get.context!),
          Get.context!);
      Navigator.pushAndRemoveUntil(
          Get.context!,
          CupertinoPageRoute(builder: (_) => const AuthScreen()),
          (route) => false);
    } else {
      _isPhoneNumberVerificationButtonLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  // for phone verification
  bool _isPhoneNumberVerificationButtonLoading = false;
  bool _isOTPLoading = false;
  bool get isPhoneNumberVerificationButtonLoading =>
      _isPhoneNumberVerificationButtonLoading;
  bool get isOTPLoading => _isOTPLoading;
  String _email = '';
  String _phone = '';
  String get email => _email;
  String get phone => _phone;

  updateEmail(String email) {
    _email = email;
    notifyListeners();
  }

  updatePhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  String _verificationCode = '';
  String get verificationCode => _verificationCode;
  bool _isEnableVerificationCode = false;
  bool get isEnableVerificationCode => _isEnableVerificationCode;

  updateVerificationCode(String query) {
    if (query.length == 4) {
      _isEnableVerificationCode = true;
    } else {
      _isEnableVerificationCode = false;
    }
    _verificationCode = query;
    notifyListeners();
  }

  String getUserToken() {
    return authServiceInterface.getUserToken();
  }

  String? getGuestToken() {
    return authServiceInterface.getGuestIdToken();
  }

  bool isLoggedIn() {
    return authServiceInterface.isLoggedIn();
  }

  bool isGuestIdExist() {
    return authServiceInterface.isGuestIdExist();
  }

  Future<bool> clearSharedData() {
    return authServiceInterface.clearSharedData();
  }

  Future<bool> clearGuestId() async {
    return await authServiceInterface.clearGuestId();
  }

  void saveUserEmail(String email, String password) {
    authServiceInterface.saveUserEmailAndPassword(email, password);
  }

  String getUserEmail() {
    return authServiceInterface.getUserEmail();
  }

  Future<bool> clearUserEmailAndPassword() async {
    return authServiceInterface.clearUserEmailAndPassword();
  }

  String getUserPassword() {
    return authServiceInterface.getUserPassword();
  }

  Future<ApiResponse> forgetPassword(String email) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await authServiceInterface.forgetPassword(email.replaceAll('+', ''));
    _isLoading = false;

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      showCustomSnackBar(apiResponse.response?.data['message'], Get.context!,
          isError: false);
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<void> getGuestIdUrl() async {
    ApiResponse apiResponse = await authServiceInterface.getGuestId();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      authServiceInterface
          .saveGuestId(apiResponse.response!.data['guest_id'].toString());
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }
}
