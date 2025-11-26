import 'package:flutter/material.dart';
import 'package:pchr/screens/notifications/notifications_screen.dart';
import 'package:pchr/utils/nav_utils.dart';

import '../constants/app_colors.dart';

class NotificationsBtn extends StatelessWidget {
  const NotificationsBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.navigateTo(NotificationsScreen());
      },
      child: Container(
        height: 34,
        width: 34,
        decoration: BoxDecoration(
          color: primaryBlue,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(
          Icons.notifications_none_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
