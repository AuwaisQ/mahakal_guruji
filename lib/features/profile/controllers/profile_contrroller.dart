import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mahakal/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:mahakal/data/model/api_response.dart';
import 'package:mahakal/data/model/response_model.dart';
import 'package:mahakal/features/profile/domain/models/profile_model.dart';
import 'package:mahakal/features/profile/domain/services/profile_service_interface.dart';
import 'package:mahakal/helper/api_checker.dart';
import 'package:mahakal/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/datasource/remote/http/httpClient.dart';
import '../../../utill/app_constants.dart';

class ProfileController extends ChangeNotifier {
  final ProfileServiceInterface? profileServiceInterface;
  ProfileController({required this.profileServiceInterface});

  ProfileModel? _userInfoModel;
  bool _isLoading = false;
  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;
  double? _balance;
  double? get balance => _balance;
  ProfileModel? get userInfoModel => _userInfoModel;
  bool get isLoading => _isLoading;
  double? loyaltyPoint = 0;
  String userID = '-1';
  String userNAME = 'test';
  String userPHONE = '12345';
  String userEMAIL = 'email';
  String userIMAGE = 'image';
  String userGender = 'gender';
  String userDob = '1234';
  String userTob = '1234';
  String userPob = '1234';
  String sipUser = '1234';
  String sipPass = '1234';

  Future<String> getUserInfo(BuildContext context) async {
    ApiResponse apiResponse = await profileServiceInterface!.getProfileInfo();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _userInfoModel = ProfileModel.fromJson(apiResponse.response!.data);
      userID = _userInfoModel!.id.toString();
      
      // Store user ID in SharedPreferences for persistent access
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', userID);
      } catch (e) {
        print('Error storing user_id in SharedPreferences: $e');
      }
      
      _balance = _userInfoModel?.walletBalance ?? 0;
      loyaltyPoint = _userInfoModel?.loyaltyPoint ?? 0;
      userNAME =
          "${_userInfoModel!.fName?.toString() ?? ''} ${_userInfoModel!.lName?.toString() ?? ''}";
      userPHONE = _userInfoModel?.phone?.toString() ?? '';
      userEMAIL = _userInfoModel?.email?.toString() ?? '';
      userIMAGE = _userInfoModel?.image?.toString() ?? '';
      userGender = _userInfoModel?.gender?.toString() ?? '';
      userDob = _userInfoModel?.dob?.toString() ?? '';
      userTob = _userInfoModel?.tob?.toString() ?? '';
      userPob = _userInfoModel?.pob?.toString() ?? '';
      sipUser = _userInfoModel?.sipUsername?.toString() ?? '';
      sipPass = _userInfoModel?.sipPassword?.toString() ?? '';

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('sipUser', sipUser);
        await prefs.setString('sipPass', sipPass);
      } catch (_) {
        // ignore shared preferences errors
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return userID;
  }

  Future<bool> updateUserEmail(String email) async {
    print('UserId-$userID');
    print('Email-$email');
    _isLoading = true;
    var res = await HttpService()
        .postApi(AppConstants.userEmailUpdate, {'id': userID, 'email': email});
    print(res);
    if (res['status']) {
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<ApiResponse> deleteCustomerAccount(
      BuildContext context, int customerId) async {
    _isDeleting = true;
    notifyListeners();
    ApiResponse apiResponse = await profileServiceInterface!.delete(customerId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      Map map = apiResponse.response!.data;
      String message = map['message'];
      showCustomSnackBar(message, Get.context!, isError: false);
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<ResponseModel> updateUserInfo(ProfileModel updateUserModel,
      String pass, File? file, String token) async {
    _isLoading = true;
    notifyListeners();

    ResponseModel responseModel;
    http.StreamedResponse response = await profileServiceInterface!
        .updateProfile(updateUserModel, pass, file, token);
    _isLoading = false;
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String? message = map['message'];
      _userInfoModel = updateUserModel;
      responseModel = ResponseModel(message, true);
      Navigator.of(Get.context!).pop();
    } else {
      responseModel = ResponseModel(
          '${response.statusCode} ${response.reasonPhrase}', false);
    }
    notifyListeners();
    return responseModel;
  }
}
