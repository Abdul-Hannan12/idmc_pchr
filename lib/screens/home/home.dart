import 'package:flutter/material.dart';
import 'package:pchr/models/complaint/complaint.dart';
import 'package:pchr/screens/faqs/faqs.dart';
import 'package:pchr/screens/complaint_form/complaint_form.dart';
import 'package:pchr/screens/home/widgets/home_item.dart';
import 'package:pchr/screens/online_support/online_support.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:pchr/utils/nav_utils.dart';
import 'package:pchr/widgets/notifications_btn.dart';
import 'package:pchr/screens/home/widgets/report_threat_btn.dart';
import 'package:pchr/utils/size_utils.dart';

import '../../constants/app_colors.dart';
import '../../widgets/drawer_btn.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<Map<String, dynamic>> items = [
    {
      "name": "complaint",
      "title": context.tr("report_a_complaint"),
      "ontap": () {
        context.navigateTo(
          ComplaintFormScreen(complaintType: ComplaintCategory.general),
        );
      },
    },
    {
      "name": "threat",
      "title": context.tr("report_physical_threat"),
      "ontap": () {
        context.navigateTo(
          ComplaintFormScreen(complaintType: ComplaintCategory.physicalThreat),
        );
      },
    },
    {
      "name": "medical_aid",
      "title": context.tr("request_medical_aid"),
      "ontap": () {
        context.navigateTo(
          ComplaintFormScreen(complaintType: ComplaintCategory.medicalAid),
        );
      },
    },
    {
      "name": "digital_threat",
      "title": context.tr("report_digital_threat"),
      "ontap": () {
        context.navigateTo(
          ComplaintFormScreen(complaintType: ComplaintCategory.digitalThreat),
        );
      },
    },
    {
      "name": "online_support",
      "title": context.tr("online_support"),
      "ontap": () {
        context.navigateTo(OnlineSupportScreen());
      },
    },
    {
      "name": "faq",
      "title": context.tr("faqs"),
      "ontap": () {
        context.navigateTo(FaqsScreen());
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DrawerBtn(),
              NotificationsBtn(),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            context.tr("welcome"),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: black,
            ),
          ),
          Text(
            context.tr("we_are_here_to_help_you_out"),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: darkGrey,
            ),
          ),
          SizedBox(height: context.percentHeight(4)),
          ReportThreatBtn(),
          SizedBox(height: context.percentHeight(4.5)),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: context.percentWidth(8),
                mainAxisSpacing: context.percentWidth(4),
                mainAxisExtent: context.percentHeight(15),
              ),
              itemBuilder: (context, index) {
                return HomeItem(
                  onTap: items[index]["ontap"],
                  iconName: items[index]["name"],
                  title: items[index]["title"],
                );
              },
              itemCount: items.length,
            ),
          ),
        ],
      ),
    );
  }
}
