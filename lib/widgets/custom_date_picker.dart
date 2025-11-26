import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pchr/constants/app_colors.dart';

class CustomDatePicker extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function? onDatePicked;

  const CustomDatePicker({
    super.key,
    this.controller,
    required this.label,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDatePicked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: primaryBlue,
          ),
        ),
        const SizedBox(height: 10),
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
            controller: controller,
            readOnly: true,
            onTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              final DateTime? date = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: firstDate ?? DateTime(1900),
                lastDate: lastDate ?? DateTime.now(),
              );
              controller?.text = DateFormat('yyyy-MM-dd').format(
                date ?? DateTime.now(),
              );
              if (onDatePicked != null) onDatePicked!();
            },
            decoration: InputDecoration(
              filled: true,
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
