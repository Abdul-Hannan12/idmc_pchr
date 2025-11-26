import 'package:flutter/material.dart';
import 'package:pchr/constants/app_colors.dart';
import 'package:pchr/utils/size_utils.dart';

class HomeItem extends StatelessWidget {
  final String iconName;
  final String title;
  final GestureTapCallback? onTap;
  const HomeItem({
    super.key,
    required this.iconName,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(15),
        bottomLeft: Radius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
          border: Border.all(color: primaryBlue),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 0),
              blurRadius: 10,
              color: Colors.black26,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              height: context.percentHeight(7),
              'assets/icons/$iconName.png',
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: mildBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
