import 'package:flutter/material.dart';
import 'package:mahakal/localization/language_constrants.dart';
import 'package:mahakal/utill/custom_themes.dart';
import 'package:mahakal/utill/dimensions.dart';
import 'package:mahakal/utill/images.dart';

class PromiseWidget extends StatelessWidget {
  const PromiseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double width = 30;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Column(children: [
          SizedBox(
            width: width,
            child: Image.asset(Images.iconFast),
          ),
          Padding(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
              child: Text(getTranslated('fast_delivery', context)!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style:
                      textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)))
        ])),
        const SizedBox(
          width: Dimensions.paddingSizeDefault,
        ),
        Expanded(
            child: Column(children: [
          SizedBox(
            width: width,
            child: Image.asset(Images.safePayment),
          ),
          Padding(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
              child: Text(getTranslated('safe_payment', context)!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style:
                      textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)))
        ])),
        const SizedBox(
          width: Dimensions.paddingSizeDefault,
        ),
        Expanded(
            child: Column(children: [
          SizedBox(
            width: width,
            child: Image.asset(Images.hundredParAuthentic),
          ),
          Padding(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
              child: Text(getTranslated('authentic_product', context)!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style:
                      textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)))
        ])),
      ],
    );
  }
}
