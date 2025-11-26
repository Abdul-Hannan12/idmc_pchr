import 'package:flutter/material.dart';
import 'package:pchr/constants/app_colors.dart';
import 'package:pchr/utils/localization_utils.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> notifications = [
      {
        "title": "Complaint Status Updated",
        "description": "Your complaint has been completed!",
      },
      {
        "title": "Complaint Status Updated",
        "description": "Your complaint is in progress!",
      },
      {
        "title": "Complaint Submitted",
        "description": "Your Complaint has been submitted successfully",
      },
      {
        "title": "Emergency Alert Sent",
        "description": "Emergency alert has been sent successfully",
      },
      {
        "title": "Complaint Submitted",
        "description": "Your Complaint has been submitted successfully",
      },
    ];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          centerTitle: true,
          title: Text(context.tr("notifications")),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(notifications[index]['title']!),
              subtitle: Text(notifications[index]['description']!),
              leading: Icon(Icons.notifications),
            );
          },
          itemCount: notifications.length,
        ),
      ),
    );
  }
}
