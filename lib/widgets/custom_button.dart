import 'package:flutter/material.dart';
import 'package:pchr/constants/app_colors.dart';
import 'package:pchr/utils/size_utils.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color? bgColor, textColor;
  final double? fontSize, height, width;
  final Size? size;
  final GestureTapCallback? onTap;
  final bool disabled, loading;
  const CustomButton({
    super.key,
    required this.text,
    this.bgColor,
    this.height,
    this.width,
    this.textColor,
    this.fontSize,
    this.size,
    this.onTap,
    this.disabled = false,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading || disabled ? null : onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: height ?? size?.height ?? 50,
        width: width ?? size?.width ?? context.percentWidth(55.5),
        decoration: BoxDecoration(
          color: disabled ? grey : bgColor ?? primaryBlue,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize ?? 18,
            ),
          ),
        ),
      ),
    );
  }
}
