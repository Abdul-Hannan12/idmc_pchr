import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pchr/constants/app_colors.dart';

class OtpField extends StatefulWidget {
  final int fieldCount;
  final double size;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  const OtpField({
    super.key,
    this.fieldCount = 4,
    this.size = 60,
    this.controller,
    this.onChanged,
  });

  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField> {
  Map<int, TextEditingController> controllers = {};
  Map<int, String> controllerValues = {};
  Map<int, FocusNode> focusNodes = {};

  @override
  void initState() {
    initiateControllers();
    super.initState();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  void initiateControllers() {
    for (int i = 1; i <= widget.fieldCount; i++) {
      controllers[i] = TextEditingController();
      focusNodes[i] = FocusNode();
    }
  }

  void disposeControllers() {
    for (int i = 1; i <= widget.fieldCount; i++) {
      controllers[i]?.dispose();
      focusNodes[i]?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: List.generate(
        widget.fieldCount,
        (index) {
          return Container(
            height: widget.size,
            width: widget.size,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color:
                    FocusManager.instance.primaryFocus == focusNodes[index + 1]
                        ? primaryOrange
                        : Colors.transparent,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 7,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: TextFormField(
              controller: controllers[index + 1],
              focusNode: focusNodes[index + 1],
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              keyboardType: TextInputType.number,
              maxLength: 1,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w500,
                color: primaryBlue,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                counterText: '',
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 4,
                ),
              ),
              onTap: () {
                setState(() {});
              },
              onChanged: (value) {
                controllerValues[index + 1] = value;
                final combinedValue = controllerValues.values.join();
                widget.controller?.text = combinedValue;
                widget.onChanged?.call(combinedValue);
                if (value.length == 1) {
                  if (index < widget.fieldCount) {
                    if (index == (widget.fieldCount - 1)) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    } else {
                      FocusScope.of(context).nextFocus();
                    }
                  }
                } else if (value.isEmpty) {
                  if (index != 0) {
                    FocusScope.of(context).previousFocus();
                  }
                }
                setState(() {});
              },
            ),
          );
        },
      ),
    );
  }
}
