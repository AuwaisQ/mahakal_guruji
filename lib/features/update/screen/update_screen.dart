import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mahakal/common/basewidget/custom_button_widget.dart';
import 'package:mahakal/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:mahakal/features/splash/controllers/splash_controller.dart';
import 'package:mahakal/localization/language_constrants.dart';
import 'package:mahakal/main.dart';
import 'package:mahakal/utill/custom_themes.dart';
import 'package:mahakal/utill/dimensions.dart';
import 'package:mahakal/utill/images.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              // color: Theme.of(context).primaryColor,
              Images.logoWithNameImage,
              width: MediaQuery.of(context).size.height * 0.4,
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text(
              "Update App",
              style: robotoBold.copyWith(
                  fontSize: MediaQuery.of(context).size.height * 0.023,
                  color: Theme.of(context).primaryColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text(
              "Update your App and get latest features provided by Mahakal.com",
              style: textRegular.copyWith(
                  fontSize: MediaQuery.of(context).size.height * 0.0175,
                  color: Theme.of(context).disabledColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            CustomButton(
                buttonText: "Update Now",
                onTap: () async {
                  String? appUrl = 'https://google.com';
                  if (Platform.isAndroid) {
                    appUrl =
                        Provider.of<SplashController>(context, listen: false)
                            .configModel
                            ?.userAppVersionControl
                            ?.forAndroid
                            ?.link;
                  } else if (Platform.isIOS) {
                    appUrl =
                        Provider.of<SplashController>(context, listen: false)
                            .configModel
                            ?.userAppVersionControl
                            ?.forIos
                            ?.link;
                  }
                  if (await canLaunchUrlString(appUrl!)) {
                    launchUrlString(appUrl,
                        mode: LaunchMode.externalApplication);
                  } else {
                    showCustomSnackBar(
                        '${getTranslated('can_not_launch', Get.context!)!}  $appUrl',
                        Get.context!);
                  }
                }),
          ]),
        ),
      ),
    );
  }
}
