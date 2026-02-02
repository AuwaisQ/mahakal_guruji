import 'package:flutter/material.dart';
import 'package:mahakal/features/order_details/controllers/order_details_controller.dart';
import 'package:mahakal/helper/price_converter.dart';
import 'package:mahakal/localization/language_constrants.dart';
import 'package:mahakal/utill/color_resources.dart';
import 'package:mahakal/utill/dimensions.dart';
import 'package:mahakal/common/basewidget/amount_widget.dart';

class OrderAmountCalculation extends StatelessWidget {
  final double itemTotalAmount;
  final double discount;
  final double? eeDiscount;
  final double tax;
  final double shippingCost;
  final OrderDetailsController orderProvider;
  const OrderAmountCalculation(
      {super.key,
      required this.itemTotalAmount,
      required this.discount,
      this.eeDiscount,
      required this.tax,
      required this.shippingCost,
      required this.orderProvider});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        color: Theme.of(context).highlightColor,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AmountWidget(
              title: getTranslated('sub_total', context),
              amount: PriceConverter.convertPrice(context, itemTotalAmount)),
          orderProvider.orders!.orderType == "POS"
              ? const SizedBox()
              : AmountWidget(
                  title: getTranslated('shipping_fee', context),
                  amount: PriceConverter.convertPrice(context, shippingCost)),
          AmountWidget(
              title: getTranslated('discount', context),
              amount: PriceConverter.convertPrice(context, discount)),
          orderProvider.orders!.orderType == "POS"
              ? AmountWidget(
                  title: getTranslated('extra_discount', context),
                  amount: PriceConverter.convertPrice(context, eeDiscount))
              : const SizedBox(),
          AmountWidget(
            title: getTranslated('coupon_voucher', context),
            amount: PriceConverter.convertPrice(
                context, orderProvider.orders!.discountAmount),
          ),
          AmountWidget(
              title: getTranslated('tax', context),
              amount: PriceConverter.convertPrice(context, tax)),
          const Padding(
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeExtraSmall),
            child: Divider(height: 2, color: ColorResources.hintTextColor),
          ),
          AmountWidget(
            title: getTranslated('total_payable', context),
            amount: PriceConverter.convertPrice(
                context,
                (itemTotalAmount +
                    shippingCost -
                    eeDiscount! -
                    orderProvider.orders!.discountAmount! -
                    discount +
                    tax)),
          ),
        ]));
  }
}
