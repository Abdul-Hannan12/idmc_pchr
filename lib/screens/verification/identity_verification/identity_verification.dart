// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pchr/constants/app_colors.dart';
import 'package:pchr/screens/verification/provider/verification_provider.dart';
import 'package:pchr/screens/verification/verification_status/verification_status.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:pchr/utils/nav_utils.dart';
import 'package:pchr/utils/size_utils.dart';
import 'package:pchr/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import 'widgets/scan_id_card_widget.dart';

class IdentityVerificationScreen extends StatelessWidget {
  const IdentityVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: ChangeNotifierProvider<VerificationProvider>(
              create: (context) => VerificationProvider(),
              builder: (context, child) {
                return Column(
                  children: [
                    SizedBox(height: context.percentHeight(5)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: black,
                          ),
                        ),
                        SizedBox(
                          width: context.percentWidth(70),
                          child: Column(
                            children: [
                              Text(
                                context.tr("identity_verification"),
                                style: TextStyle(
                                  color: black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                context.tr("we_need_your_cnic"),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: darkGrey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: context.percentHeight(4)),
                    Image.asset(
                      width: context.percentWidth(80),
                      'assets/images/dummy_cnic.png',
                    ),
                    SizedBox(height: context.percentHeight(3)),
                    Text(
                      context.tr("scan_your_id_card"),
                      style: TextStyle(
                        color: black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: context.percentHeight(5)),
                    ScanIdCardWidget(),
                    SizedBox(height: context.percentHeight(7)),
                    Selector<VerificationProvider, File?>(
                      selector: (context, provider) => provider.selectedId,
                      builder: (context, file, child) {
                        return CustomButton(
                          onTap: () async {
                            // context.showLoading();
                            // final bool success = await context
                            //     .read<VerificationProvider>()
                            //     .verifyId();
                            // if (success) {
                            //   context.pop();
                            //   context.navigateAndRemoveCurrentPage(
                            //     IdentityVerificationScreen(),
                            //   );
                            // } else {
                            //   context.pop();
                            // }
                            context.navigateTo(VerificationStatusScreen());
                          },
                          disabled: file == null,
                          text: context.tr("continue"),
                        );
                      },
                    ),
                    SizedBox(height: context.percentHeight(3.75)),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
