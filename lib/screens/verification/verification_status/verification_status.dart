import 'package:flutter/material.dart';
import 'package:pchr/screens/dashboard/dashboard.dart';
import 'package:pchr/screens/verification/provider/verification_provider.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:pchr/utils/nav_utils.dart';
import 'package:pchr/utils/size_utils.dart';
import 'package:pchr/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/hive_boxes.dart';
import '../../auth/login/login_screen.dart';

class VerificationStatusScreen extends StatefulWidget {
  const VerificationStatusScreen({super.key});

  @override
  State<VerificationStatusScreen> createState() =>
      _VerificationStatusScreenState();
}

class _VerificationStatusScreenState extends State<VerificationStatusScreen> {
  Future<VerificationStatus>? verificationStatus;

  @override
  void initState() {
    getStatus();
    super.initState();
  }

  void getStatus() {
    verificationStatus =
        context.read<VerificationProvider>().getVerificationstatus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: context.percentHeight(5),
            ),
            child: Column(
              children: [
                Text(
                  context.tr("verification_status"),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  context.tr("wait_to_use_app_until_identity_verified"),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: darkGrey,
                  ),
                ),
                SizedBox(height: context.percentHeight(20)),
                Text(
                  context.tr("your_information_is_submitted"),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: black,
                  ),
                ),
                SizedBox(height: context.percentHeight(15)),
                Expanded(
                  child: FutureBuilder<VerificationStatus>(
                    future: verificationStatus,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: primaryOrange,
                            strokeWidth: 5,
                          ),
                        );
                      } else if (snapshot.hasData) {
                        return Column(
                          children: [
                            Text(
                              snapshot.data!.prettyName,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: primaryBlue,
                              ),
                            ),
                            const Spacer(),
                            CustomButton(
                              onTap: () {
                                if (snapshot.data ==
                                    VerificationStatus.approved) {
                                  context.navigateOff(Dashboard());
                                } else {
                                  getStatus();
                                }
                              },
                              size: Size(double.infinity, 60),
                              text: snapshot.data == VerificationStatus.approved
                                  ? context.tr("dashboard")
                                  : context.tr("retry"),
                              textColor:
                                  snapshot.data == VerificationStatus.approved
                                      ? Colors.white
                                      : black,
                              bgColor:
                                  snapshot.data == VerificationStatus.approved
                                      ? mildBlue
                                      : Colors.yellow.withAlpha(200),
                            ),
                            if (snapshot.data !=
                                VerificationStatus.approved) ...[
                              SizedBox(height: 10),
                              CustomButton(
                                onTap: () async {
                                  await userBox.clear();
                                  // ignore: use_build_context_synchronously
                                  context.navigateOff(LoginScreen());
                                },
                                size: Size(double.infinity, 60),
                                text: context.tr("logout"),
                                textColor: Colors.white,
                                bgColor: red.withAlpha(200),
                              ),
                            ],
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            Text(
                              context.tr("couldn't_get_status"),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: primaryBlue,
                              ),
                            ),
                            const Spacer(),
                            CustomButton(
                              onTap: () {
                                getStatus();
                              },
                              size: Size(double.infinity, 60),
                              text: context.tr("retry"),
                              textColor: black,
                              bgColor: Colors.yellow.withAlpha(200),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
