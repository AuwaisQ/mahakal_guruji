import 'package:flutter/material.dart';

class PanditBottomNavItem extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Function? onTap;
  final bool isSelected;
  const PanditBottomNavItem(
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
            SizedBox(height: isSelected ? 5.0 : 10.0),
            Text(
              title,
              style: TextStyle(
                color:
                isSelected ? Theme.of(context).cardColor : Colors.white54,
              ),
            )
          ],
        ),
      ),
    );
  }
}
