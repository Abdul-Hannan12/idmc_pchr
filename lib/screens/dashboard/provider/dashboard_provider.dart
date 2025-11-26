import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  final pageController = PageController(initialPage: 0);
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void updatePage(int index) {
    if (_currentIndex == index) return;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
    _currentIndex = index;
    notifyListeners();
  }

  void backToHome() {
    if (_currentIndex == 0) return;
    pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
    _currentIndex = 0;
    notifyListeners();
  }
}
