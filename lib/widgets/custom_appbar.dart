import 'package:flutter/material.dart';
import 'package:pchr/utils/nav_utils.dart';
import 'package:pchr/utils/size_utils.dart';

import '../constants/app_colors.dart';

class CustomAppbar extends StatelessWidget {
  final Widget? title;
  final String titleText;
  final String? subtitleText;
  final Widget? action;
  final VoidCallback? onBackPressed;
  final double? bottomSpacing;
  const CustomAppbar({
    super.key,
    this.title,
    this.action,
    this.bottomSpacing,
    required this.titleText,
    this.subtitleText,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: bottomSpacing ?? context.percentHeight(4),
      ),
      height: context.percentHeight(12),
      color: primaryBlue,
      child: Stack(
        children: [
          Positioned(
            left: 15,
            top: 0,
            bottom: 0,
            child: IconButton(
              onPressed: onBackPressed ??
                  () {
                    context.pop();
                  },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          if (action != null)
            Positioned(
              right: 15,
              top: 0,
              bottom: 0,
              child: action!,
            ),
          Positioned(
            left: context.percentWidth(15),
            right: context.percentWidth(15),
            top: 0,
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (title != null) ...[
                  title!,
                  const SizedBox(height: 5),
                ],
                Text(
                  titleText,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: title != null ? 15 : 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitleText != null)
                  Text(
                    subtitleText!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: lightWhite,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
