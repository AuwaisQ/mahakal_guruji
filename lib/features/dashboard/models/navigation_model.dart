import 'package:flutter/material.dart';

import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';

class NavigationModel {
  String name;
  String icon;
  Widget screen;
  NavigationModel(
      {required this.name, required this.icon, required this.screen});
}

class BottomNavItem extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Function? onTap;
  final bool isSelected;
  const BottomNavItem(
      {super.key,
      required this.iconData,
      this.onTap,
      this.isSelected = false,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap as void Function()?,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: isSelected ? Theme.of(context).cardColor : Colors.white54,
              size: 25,
            ),
            SizedBox(
                height: isSelected
                    ? Dimensions.paddingSizeExtraSmall
                    : Dimensions.paddingSizeSmall),
            Text(
              title,
              style: titleHeader.copyWith(
                  color:
                      isSelected ? Theme.of(context).cardColor : Colors.white54,
                  fontSize: 12),
            )
            // isSelected ? Text(
            //   title,
            //   style: titleHeader.copyWith(color: isSelected ? Theme.of(context).cardColor : Theme.of(context).disabledColor.withOpacity(0.8), fontSize: 12),
            // ): const SizedBox(),
          ],
        ),
      ),
    );
  }
}
