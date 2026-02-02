import 'package:flutter/material.dart';
import 'package:mahakal/features/checkout/controllers/checkout_controller.dart';
import 'package:mahakal/theme/controllers/theme_controller.dart';
import 'package:mahakal/utill/custom_themes.dart';
import 'package:mahakal/utill/dimensions.dart';
import 'package:mahakal/common/basewidget/custom_image_widget.dart';
import 'package:provider/provider.dart';

class CustomCheckBoxWidget extends StatelessWidget {
  final int index;
  final bool isDigital;
  final String? icon;
  final String name;
  final String title;
  const CustomCheckBoxWidget(
      {super.key,
      required this.index,
      this.isDigital = false,
      this.icon,
      required this.name,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutController>(
      builder: (context, order, child) {
        return InkWell(
          onTap: () => order.setDigitalPaymentMethodName(index, name),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Container(

              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault, vertical: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: order.paymentMethodIndex == index
                      ? Colors.green.withOpacity(0.6)
                      : Colors.grey.withOpacity(0.3),
                  width: order.paymentMethodIndex == index ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  // Checkbox
                  Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor:
                      Provider.of<ThemeController>(context, listen: false).darkTheme
                          ? Colors.white60
                          : Colors.grey.shade400,
                    ),
                    child: Checkbox(
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      value: order.paymentMethodIndex == index,
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      onChanged: (bool? value) {
                        order.setDigitalPaymentMethodName(index, name);
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Payment Icon
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green.withOpacity(0.08),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: CustomImageWidget(image: icon!),
                  ),

                  const SizedBox(width: 12),

                  // Text
                  Expanded(
                    child: Text(
                      title,
                      style: textRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
