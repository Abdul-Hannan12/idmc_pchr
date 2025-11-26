import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pchr/constants/app_colors.dart';
import 'package:pchr/utils/size_utils.dart';

extension DialogUtils on BuildContext {
  void showSnackbar(
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
      ),
    );
  }

  void showBottomDialog(Widget body) {
    showDialog(
      context: this,
      builder: (context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: context.percentWidth(70),
            margin: EdgeInsets.only(bottom: context.percentHeight(10)),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: body,
          ),
        );
      },
    );
  }

  void showLoading() {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                color: Colors.black.withValues(alpha: 0.05),
              ),
            ),
            Center(
              child: CircularProgressIndicator(
                color: primaryOrange,
                strokeWidth: 5,
              ),
            ),
          ],
        );
      },
    );
  }

  void showDisclaimer(String text) {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Disclaimer"),
        content: SizedBox(
          height: percentHeight(80),
          child: SingleChildScrollView(
            child: Text(
              text,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
