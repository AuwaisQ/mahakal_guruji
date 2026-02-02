import 'package:flutter/cupertino.dart';
import 'package:mahakal/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:mahakal/data/model/api_response.dart';
import 'package:mahakal/features/contact_us/domain/models/contact_us_body.dart';
import 'package:mahakal/features/contact_us/domain/services/contact_us_service_interface.dart';
import 'package:mahakal/helper/api_checker.dart';
import 'package:mahakal/localization/language_constrants.dart';
import 'package:mahakal/main.dart';

class ContactUsController extends ChangeNotifier {
  ContactUsServiceInterface contactUsServiceInterface;
  ContactUsController({required this.contactUsServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ApiResponse> contactUs(ContactUsBody contactUsBody) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await contactUsServiceInterface.add(contactUsBody);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      showCustomSnackBar(
          '${getTranslated('message_sent_successfully', Get.context!)}',
          Get.context!,
          isError: false);
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }
}
