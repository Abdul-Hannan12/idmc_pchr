import 'package:flutter/material.dart';
import 'package:pchr/constants/app_colors.dart';

class CustomSelector extends StatefulWidget {
  final double? height, width;
  final String firstTitle, secondTitle;
  final ValueChanged<bool>? onChanged;

  const CustomSelector({
    super.key,
    this.height,
    this.width,
    this.onChanged,
    this.firstTitle = '',
    this.secondTitle = '',
  });

  @override
  State<CustomSelector> createState() => _CustomSelectorState();
}

class _CustomSelectorState extends State<CustomSelector> {
  final isLeft = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 2,
          color: primaryBlue,
        ),
      ),
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return ValueListenableBuilder<bool>(
                valueListenable: isLeft,
                builder: (context, isLeft, child) {
                  return AnimatedAlign(
                    alignment:
                        isLeft ? Alignment.centerLeft : Alignment.centerRight,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      height: double.infinity,
                      width: constraints.maxWidth / 2,
                    ),
                  );
                },
              );
            },
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    if (!isLeft.value) {
                      isLeft.value = true;
                      widget.onChanged?.call(true);
                    }
                  },
                  child: Center(
                    child: ValueListenableBuilder<bool>(
                      valueListenable: isLeft,
                      builder: (context, isLeft, child) {
                        return AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            color: isLeft ? Colors.white : primaryBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          child: Text(widget.firstTitle),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    if (isLeft.value) {
                      isLeft.value = false;
                      widget.onChanged?.call(false);
                    }
                  },
                  child: Center(
                    child: ValueListenableBuilder<bool>(
                      valueListenable: isLeft,
                      builder: (context, isLeft, child) {
                        return AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            color: isLeft ? primaryBlue : Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          child: Text(widget.secondTitle),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
