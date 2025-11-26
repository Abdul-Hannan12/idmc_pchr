import 'package:flutter/material.dart';
import 'package:pchr/constants/app_colors.dart';
import 'package:pchr/screens/complaint_log/complaint_log.dart';
import 'package:pchr/screens/dashboard/provider/dashboard_provider.dart';
import 'package:pchr/screens/edit_profile/edit_profile.dart';
import 'package:pchr/screens/emergency_numbers/emergency_numbers.dart';
import 'package:pchr/screens/online_support/online_support.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:pchr/utils/nav_utils.dart';
import 'package:pchr/utils/size_utils.dart';
import 'package:provider/provider.dart';

import '../../widgets/notifications_btn.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final List<Map<String, dynamic>> profileItems = [
    {
      'iconName': "complaint",
      'title': context.tr("complaint_log"),
      'ontap': () {
        context.navigateTo(ComplaintLogScreen());
      },
    },
    {
      'iconName': "file",
      'title': context.tr("my_profile"),
      'ontap': () {
        context.navigateTo(EditProfileScreen());
      },
    },
    {
      'iconName': "emergency",
      'title': context.tr("emergency_numbers"),
      'ontap': () {
        context.navigateTo(EmergencyNumbersScreen());
      },
    },
    {
      'iconName': "help",
      'title': context.tr("help_center"),
      'ontap': () {
        context.navigateTo(OnlineSupportScreen());
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: context.percentHeight(23.5),
              color: primaryBlue,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      context.read<DashboardProvider>().backToHome();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Text(
                        context.tr("account_information"),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        context.tr("info_about_account"),
                        style: TextStyle(
                          color: lightWhite,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  NotificationsBtn(),
                ],
              ),
            ),
            Positioned(
              bottom: -context.percentWidth(19),
              left: (context.width - context.percentWidth(38) - 10) / 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(5),
                child: CircleAvatar(
                  radius: context.percentWidth(19),
                  foregroundImage: AssetImage("assets/images/dummy_dp.png"),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: context.percentWidth(19) + context.percentHeight(4)),
        ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 7,
                    color: Colors.black.withValues(alpha: 0.08),
                  ),
                ],
              ),
              child: ListTile(
                onTap: profileItems[index]['ontap'],
                leading: Image.asset(
                  "assets/icons/profile_${profileItems[index]['iconName']}.png",
                ),
                title: Text(
                  profileItems[index]['title'],
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: primaryBlue,
                  size: 12,
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemCount: profileItems.length,
        ),
      ],
    );
  }
}
