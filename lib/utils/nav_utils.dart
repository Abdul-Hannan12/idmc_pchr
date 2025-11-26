import 'package:flutter/material.dart';

extension NavigationUtility on BuildContext {
  Future navigateTo(Widget page) {
    return Navigator.push(
      this,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future navigateAndRemoveCurrentPage(Widget page) {
    return Navigator.pushReplacement(
      this,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future navigateOff(Widget page) {
    return Navigator.pushAndRemoveUntil(
      this,
      MaterialPageRoute(builder: (context) => page),
      (route) => false,
    );
  }

  void pop() {
    Navigator.pop(this);
  }
}
