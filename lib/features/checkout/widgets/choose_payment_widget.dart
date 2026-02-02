import 'package:flutter/material.dart';
import 'package:mahakal/features/checkout/controllers/checkout_controller.dart';
import 'package:mahakal/localization/language_constrants.dart';
import 'package:mahakal/features/splash/controllers/splash_controller.dart';
import 'package:mahakal/utill/custom_themes.dart';
import 'package:mahakal/utill/dimensions.dart';
import 'package:mahakal/utill/images.dart';
import 'package:mahakal/features/checkout/widgets/payment_method_bottom_sheet_widget.dart';
import 'package:provider/provider.dart';

import '../../../common/basewidget/custom_button_widget.dart';
import '../../../localization/controllers/localization_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import 'custom_check_box_widget.dart';

class ChoosePaymentWidget extends StatelessWidget {
  final bool onlyDigital;
  const ChoosePaymentWidget({super.key, required this.onlyDigital});

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutController>(builder: (context, orderProvider, _) {
      return Consumer<SplashController>(builder: (context, configProvider, _) {
        return Card(
          child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(Dimensions.paddingSizeDefault),
                color: Theme.of(context).cardColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text(
                              '${getTranslated('payment_method', context)}',
                              style: textMedium.copyWith(
                                  fontSize: Dimensions.fontSizeLarge))),
                      InkWell(
                          onTap: () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (c) => PaymentMethodBottomSheetWidget(
                                    onlyDigital: onlyDigital,
                                  )),
                          child: SizedBox(
                              width: 20,
                              child: Image.asset(Images.edit, scale: 3)))
                    ]),
                const SizedBox(
                  height: Dimensions.paddingSizeDefault,
                ),

                //New Code Added 24-Feb

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        if (Provider.of<SplashController>(context,
                                        listen: false)
                                    .configModel !=
                                null &&
                            Provider.of<SplashController>(context,
                                    listen: false)
                                .configModel!
                                .cashOnDelivery! &&
                            !onlyDigital)
                          Expanded(
                              child: CustomButton(
                                  isBorder: true,
                                  leftIcon: Images.cod,
                                  backgroundColor: orderProvider.codChecked
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).cardColor,
                                  textColor: orderProvider.codChecked
                                      ? Colors.white
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
                                  fontSize: Dimensions.fontSizeSmall,
                                  onTap: () =>
                                      orderProvider.setOfflineChecked('cod'),
                                  buttonText:
                                      '${getTranslated('cash_on_delivery', context)}')),
                        const SizedBox(width: Dimensions.paddingSizeDefault),
                        if (Provider.of<SplashController>(context,
                                        listen: false)
                                    .configModel !=
                                null &&
                            Provider.of<SplashController>(context,
                                        listen: false)
                                    .configModel!
                                    .walletStatus! ==
                                1 &&
                            Provider.of<AuthController>(context, listen: false)
                                .isLoggedIn())
                          Expanded(
                              child: CustomButton(
                                  onTap: () =>
                                      orderProvider.setOfflineChecked('wallet'),
                                  isBorder: true,
                                  leftIcon: Images.payWallet,
                                  backgroundColor: orderProvider.walletChecked
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).cardColor,
                                  textColor: orderProvider.walletChecked
                                      ? Colors.white
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
                                  fontSize: Dimensions.fontSizeSmall,
                                  buttonText:
                                      '${getTranslated('pay_via_wallet', context)}'))
                      ],
                    ),
                    if (Provider.of<SplashController>(context, listen: false)
                                .configModel !=
                            null &&
                        Provider.of<SplashController>(context, listen: false)
                            .configModel!
                            .digitalPayment!)
                      Padding(
                          padding: const EdgeInsets.only(
                              bottom: Dimensions.paddingSizeSmall,
                              top: Dimensions.paddingSizeDefault),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '${getTranslated('pay_via_online', context)}',
                                    style: textRegular),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: Dimensions.paddingSizeExtraSmall),
                                  child: Text(
                                      '${getTranslated('fast_and_secure', context)}',
                                      style: textRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: Theme.of(context).hintColor)),
                                ))
                              ])),
                    if (Provider.of<SplashController>(context, listen: false)
                                .configModel !=
                            null &&
                        Provider.of<SplashController>(context, listen: false)
                            .configModel!
                            .digitalPayment!)
                      Consumer<SplashController>(
                          builder: (context, configProvider, _) {
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: configProvider
                                  .configModel?.paymentMethods?.length ??
                              0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return CustomCheckBoxWidget(
                              index: index,
                              icon:
                                  '${configProvider.configModel?.paymentMethodImagePath}/'
                                  '${configProvider.configModel?.paymentMethods?[index].additionalDatas?.gatewayImage ?? ''}',
                              name: configProvider
                                  .configModel!.paymentMethods![index].keyName!,
                              title: configProvider
                                      .configModel!
                                      .paymentMethods![index]
                                      .additionalDatas
                                      ?.gatewayTitle ??
                                  '',
                            );
                          },
                        );
                      }),
                    if (Provider.of<SplashController>(context, listen: false)
                                .configModel !=
                            null &&
                        Provider.of<SplashController>(context, listen: false)
                                .configModel!
                                .offlinePayment !=
                            null)
                      Padding(
                          padding: const EdgeInsets.only(
                              bottom: Dimensions.paddingSizeDefault),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: orderProvider.offlineChecked
                                      ? Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.15)
                                      : null,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.paddingSizeSmall)),
                              child: Column(children: [
                                InkWell(
                                    onTap: () {
                                      if (orderProvider.offlinePaymentModel
                                                  ?.offlineMethods !=
                                              null &&
                                          orderProvider.offlinePaymentModel!
                                              .offlineMethods!.isNotEmpty) {
                                        orderProvider
                                            .setOfflineChecked('offline');
                                      }
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .paddingSizeSmall),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(Dimensions
                                                      .paddingSizeExtraSmall),
                                            ),
                                            child: Row(children: [
                                              Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                    unselectedWidgetColor:
                                                        Theme.of(context)
                                                            .primaryColor
                                                            .withOpacity(.25),
                                                  ),
                                                  child: Checkbox(
                                                      visualDensity:
                                                          VisualDensity.compact,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  Dimensions
                                                                      .paddingSizeExtraLarge)),
                                                      value: orderProvider
                                                          .offlineChecked,
                                                      activeColor: Colors.green,
                                                      onChanged:
                                                          (bool? isChecked) {
                                                        if (orderProvider
                                                                    .offlinePaymentModel
                                                                    ?.offlineMethods !=
                                                                null &&
                                                            orderProvider
                                                                .offlinePaymentModel!
                                                                .offlineMethods!
                                                                .isNotEmpty) {
                                                          orderProvider
                                                              .setOfflineChecked(
                                                                  'offline');
                                                        }
                                                      })),
                                              Text(
                                                '${getTranslated('pay_offline', context)}',
                                                style: textRegular.copyWith(),
                                              )
                                            ])))),
                                if (orderProvider.offlinePaymentModel != null &&
                                    orderProvider.offlinePaymentModel!
                                            .offlineMethods !=
                                        null &&
                                    orderProvider.offlinePaymentModel!
                                        .offlineMethods!.isNotEmpty &&
                                    orderProvider.offlineChecked)
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: Provider.of<LocalizationController>(
                                                      context,
                                                      listen: false)
                                                  .isLtr
                                              ? Dimensions.paddingSizeDefault
                                              : 0,
                                          bottom: Dimensions.paddingSizeDefault,
                                          right:
                                              Provider.of<LocalizationController>(
                                                          context,
                                                          listen: false)
                                                      .isLtr
                                                  ? 0
                                                  : Dimensions.paddingSizeDefault,
                                          top: Dimensions.paddingSizeSmall),
                                      child: SizedBox(
                                          height: 40,
                                          child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: orderProvider.offlinePaymentModel!.offlineMethods!.length,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                    onTap: () {
                                                      if (orderProvider
                                                                  .offlinePaymentModel
                                                                  ?.offlineMethods !=
                                                              null &&
                                                          orderProvider
                                                              .offlinePaymentModel!
                                                              .offlineMethods!
                                                              .isNotEmpty) {
                                                        orderProvider
                                                            .setOfflinePaymentMethodSelectedIndex(
                                                                index);
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: Dimensions
                                                              .paddingSizeExtraSmall),
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Theme.of(
                                                                      context)
                                                                  .cardColor,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      Dimensions
                                                                          .paddingSizeExtraSmall),
                                                              border: orderProvider
                                                                          .offlineMethodSelectedIndex ==
                                                                      index
                                                                  ? Border.all(
                                                                      color: Theme.of(context)
                                                                          .primaryColor,
                                                                      width: 2)
                                                                  : Border.all(
                                                                      color: Theme.of(context)
                                                                          .primaryColor
                                                                          .withOpacity(.5),
                                                                      width: .25)),
                                                          child: Padding(
                                                            padding: const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    Dimensions
                                                                        .paddingSizeDefault),
                                                            child: Center(
                                                                child: Text(orderProvider
                                                                        .offlinePaymentModel!
                                                                        .offlineMethods![
                                                                            index]
                                                                        .methodName ??
                                                                    '')),
                                                          )),
                                                    ));
                                              })))
                              ]))),
                  ],
                ),

                // Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                //   const Divider(thickness: .125,),
                //   (orderProvider.paymentMethodIndex != -1)?
                //   Row(children: [
                //     SizedBox(width: 40, child: CustomImageWidget(
                //         image: '${configProvider.configModel?.paymentMethodImagePath}/${configProvider.configModel!.paymentMethods![orderProvider.paymentMethodIndex].additionalDatas!.gatewayImage??''}')),
                //     Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                //       child: Text(configProvider.configModel!.paymentMethods![orderProvider.paymentMethodIndex].additionalDatas!.gatewayTitle??''),),
                //   ],):orderProvider.codChecked?
                //   Text(getTranslated('cash_on_delivery', context)??'') : orderProvider.offlineChecked?
                //   Text(getTranslated('offline_payment', context)??'') : orderProvider.walletChecked?
                //   Text(getTranslated('wallet_payment', context)??'') :
                //
                //   InkWell(onTap: () => showModalBottomSheet(context: context,
                //       isScrollControlled: true, backgroundColor: Colors.transparent,
                //       builder: (c) =>   PaymentMethodBottomSheetWidget(onlyDigital: onlyDigital,)),
                //     child: Row(children: [
                //       Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                //         child: Icon(Icons.add_circle_outline_outlined, size: 20, color: Theme.of(context).primaryColor),),
                //         Text('${getTranslated('add_payment_method', context)}',
                //           style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                //           maxLines: 3, overflow: TextOverflow.fade)]))]),
              ],
            ),
          ),
        );
      });
    });
  }
}
