import 'package:flutter/material.dart';
import 'package:pchr/constants/app_colors.dart';

class DrawerBtn extends StatelessWidget {
  const DrawerBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Scaffold.of(context).openDrawer();
      },
      borderRadius: BorderRadius.circular(5),
      child: Container(
        height: 34,
        width: 34,
        decoration: BoxDecoration(
          color: primaryBlue,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(
          Icons.menu,
          color: Colors.white,
        ),
      ),
    );
  }
}
