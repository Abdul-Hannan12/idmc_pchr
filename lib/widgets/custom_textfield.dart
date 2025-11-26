import 'package:flutter/material.dart';
import 'package:pchr/constants/app_colors.dart';

class CustomTextfield extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final TextInputType? keyboardType;
  final bool? isTextArea, disabled;
  final Widget? prefixIcon, suffixIcon;
  final String? defaultValue;
  const CustomTextfield({
    super.key,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.isTextArea,
    this.keyboardType,
    this.label,
    this.defaultValue,
    this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 10),
        ],
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 7,
                color: Colors.black.withValues(alpha: 0.08),
              ),
            ],
          ),
          child: TextFormField(
            enabled: disabled != null ? !disabled! : true,
            initialValue: defaultValue,
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            maxLines: isTextArea ?? false ? 4 : null,
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            decoration: InputDecoration(
              filled: true,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
