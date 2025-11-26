import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CustomDropdown extends StatefulWidget {
  final List items;
  final List? labels;
  final String? selectedValue;
  final String? label;
  final ValueChanged<String?>? onChange;
  final Text? hint;
  final TextStyle? style;
  final double? width, iconSize, maxDropdownHeight;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;
  final Color? iconColor;
  final BoxDecoration? dropdownDecoration;
  final FormFieldValidator? validator;
  const CustomDropdown({
    super.key,
    required this.items,
    required this.selectedValue,
    this.onChange,
    this.label,
    this.hint,
    this.width,
    this.padding,
    this.decoration,
    this.iconSize,
    this.iconColor,
    this.maxDropdownHeight,
    this.dropdownDecoration,
    this.style,
    this.labels,
    this.validator,
  });

  @override
  State<CustomDropdown> createState() => CustomDropdownState();
}

class CustomDropdownState extends State<CustomDropdown> {
  bool hasError = false;
  String? _errorText;

  bool validate() {
    setState(() {
      _validate();
    });
    return !hasError;
  }

  void _validate() {
    if (widget.validator != null) {
      String? validatorText = widget.validator!(widget.selectedValue);
      _errorText = validatorText;
      hasError = validatorText != null;
    } else {
      hasError = false;
      _errorText = null;
    }
  }

  List<DropdownMenuItem<String>> getMenuItems() {
    List<DropdownMenuItem<String>> menuItems = [];
    for (var i = 0; i < widget.items.length; i++) {
      menuItems.add(
        DropdownMenuItem<String>(
          value: widget.items[i],
          child: Text(
            widget.labels?[i] ?? widget.items[i],
            style: widget.style,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget.labels == null || widget.items.length == widget.labels?.length,
      'is not true. \n **labels and items must have the same length or only items should be provided**',
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 10),
        ],
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: widget.hint ??
                const Text(
                  "Select",
                ),
            items: getMenuItems(),
            value: widget.selectedValue,
            onChanged: widget.onChange,
            buttonStyleData: ButtonStyleData(
              height: 50,
              width: widget.width ?? 90,
              padding:
                  widget.padding ?? const EdgeInsets.symmetric(horizontal: 10),
              decoration: widget.decoration ??
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        blurRadius: 7,
                        color: Colors.black.withValues(alpha: 0.08),
                      ),
                    ],
                    border: Border.all(
                      color: hasError ? Colors.red : Colors.transparent,
                      width: 0.6,
                    ),
                  ),
            ),
            iconStyleData: IconStyleData(
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
              ),
              iconSize: widget.iconSize ?? 14,
              iconEnabledColor: widget.iconColor ?? Colors.grey,
              iconDisabledColor: Colors.grey[300],
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: widget.maxDropdownHeight ?? 150,
              width: widget.width ?? 90,
              decoration: widget.dropdownDecoration ??
                  const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    color: Colors.white,
                  ),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(4),
                thickness: WidgetStateProperty.all<double>(2),
                thumbVisibility: WidgetStateProperty.all<bool>(true),
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 5),
          Text(
            '     $_errorText',
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ],
    );
  }
}
