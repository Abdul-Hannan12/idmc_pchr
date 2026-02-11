// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pchr/constants/app_colors.dart';
import 'package:pchr/constants/hive_boxes.dart';
import 'package:pchr/screens/auth/login/login_screen.dart';
import 'package:pchr/screens/current_location/current_location.dart';
import 'package:pchr/utils/dialog_utils.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:pchr/utils/nav_utils.dart';
import 'package:pchr/utils/size_utils.dart';
import 'package:pchr/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../dashboard/provider/dashboard_provider.dart';
import '../../../data/network/network_api_services.dart';
import '../../../constants/app_urls.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  late final List<Map<String, dynamic>> drawerItems = [
    {
      'icon': Icons.my_location_rounded,
      'title': context.tr("current_location"),
      'ontap': () {
        context.navigateTo(CurrentLocationScreen());
      }
    },
    {
      'icon': Icons.query_stats_rounded,
      'title': context.tr("statistics"),
      'ontap': () {
        context.read<DashboardProvider>().updatePage(1);
      }
    },
    {
      'icon': Icons.person,
      'title': context.tr("account_information"),
      'ontap': () {
        context.read<DashboardProvider>().updatePage(2);
      }
    },
    {
      'icon': Icons.privacy_tip,
      'title': context.tr("privacy_policy"),
      'ontap': () async {
        try {
          await launchUrl(
            Uri.parse(
                'https://dectuple.com/privacy-policy-for-digitization-threat-system/'),
          );
        } catch (e) {
          context.showSnackbar("Couldn't Get Privacy Policy");
        }
      }
    },
    {
      'icon': Icons.info,
      'title': context.tr("app_info"),
      'ontap': () {
        PackageInfo.fromPlatform().then(
          (PackageInfo packageInfo) {
            context.showBottomDialog(
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.tr("app_information"),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: primaryOrange,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Version: ${packageInfo.version}",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
                  Text(
                    context.tr("build_to_protect_right_journalist"),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: darkGrey,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    },
    {
      'icon': Icons.delete,
      'title': context.tr("delete_account"),
      'ontap': () {
        _showDeleteConfirmationDialog(context);
      },
    },
    {
      'icon': Icons.logout,
      'title': context.tr("logout"),
      'ontap': () async {
        await userBox.clear();
        context.navigateOff(LoginScreen());
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 30, left: 20, right: 40),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    foregroundImage: AssetImage('assets/images/dummy_dp.png'),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        storedUser.name ?? "User",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: black,
                        ),
                      ),
                      Text(
                        storedUser.email ?? "abc@example.com",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: darkGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: context.percentHeight(4)),
              CustomButton(
                onTap: () {
                  context.toggleLocale();
                },
                size: Size(100, 30),
                text: context.tr("lang"),
                fontSize: 12,
                bgColor: primaryOrange,
              ),
              SizedBox(height: context.percentHeight(4)),
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          drawerItems[index]['icon'],
                          color: black,
                        ),
                        title: Text(
                          drawerItems[index]['title'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: primaryBlue,
                          ),
                        ),
                        onTap: () {
                          context.pop();
                          drawerItems[index]['ontap']?.call();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(),
                      ),
                    ],
                  );
                },
                itemCount: drawerItems.length,
              ),
              SizedBox(height: context.percentHeight(4)),
              CustomButton(
                onTap: () {
                  context.pop();
                },
                height: 35,
                text: context.tr("close"),
              ),
              SizedBox(height: context.percentHeight(2)),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool isLoading = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(context.tr("delete_account")),
              content: Text(
                context.tr("delete_account_confirmation"),
              ),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: Text(context.tr("cancel")),
                ),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });

                          try {
                            final network = NetworkApiServices();
                            final userId = storedUser.id;
                            final token = storedUser.token;

                            if (userId == null) {
                              throw Exception("User ID not found");
                            }

                            await network.postApi(
                              deleteAccountApiUrl(userId.toString()),
                              {},
                              isAuth: true,
                              token: token,
                            );

                            await userBox.clear();
                            context.navigateOff(LoginScreen());
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                            context.showSnackbar(e.toString());
                          }
                        },
                  child: isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.red,
                          ),
                        )
                      : Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
