import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahakal/localization/language_constrants.dart';
import 'package:mahakal/utill/custom_themes.dart';
import 'package:mahakal/utill/dimensions.dart';
import 'package:mahakal/utill/images.dart';
import 'package:mahakal/common/basewidget/custom_button_widget.dart';
import 'package:mahakal/features/auth/screens/auth_screen.dart';


class NotLoggedInWidget extends StatelessWidget {
  const NotLoggedInWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: Dimensions.paddingSizeDefault),
          child: SizedBox(
              width: 60,
              child: Image.asset(
                Images.loginIcon,
                color: Theme.of(context).primaryColor,
              )),
        ),
        Text(
          getTranslated('please_login', context)!,
          style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: Dimensions.paddingSizeSmall,
              bottom: Dimensions.paddingSizeLarge),
          child: Text('${getTranslated('need_to_login', context)}'),
        ),
        Center(
            child: SizedBox(
                width: 120,
                child: CustomButton(
                    buttonText: '${getTranslated('login', context)}',
                    backgroundColor: Theme.of(context).primaryColor,
                    onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const AuthScreen()))))),
        InkWell(
          onTap: () {},
              // Navigator.pushAndRemoveUntil(
              // context,
              // CupertinoPageRoute(builder: (_) => const BottomBar(pageIndex: 0)),
              // (route) => false),
          child: Padding(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
              child: Text(
                getTranslated('back_to_home', context)!,
                style: textRegular.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.underline),
              )),
        ),
      ],
    );
  }
}
