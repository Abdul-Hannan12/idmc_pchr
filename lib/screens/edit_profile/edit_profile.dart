import 'package:flutter/material.dart';
import 'package:pchr/constants/hive_boxes.dart';
import 'package:pchr/utils/dialog_utils.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:pchr/widgets/custom_appbar.dart';
import 'package:pchr/widgets/custom_textfield.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            CustomAppbar(
              titleText: context.tr("profile_information"),
              subtitleText:
                  context.tr("profile_information_about_your_account"),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 15,
                    children: [
                      Stack(
                        children: [
                          CustomTextfield(
                            disabled: true,
                            defaultValue: storedUser.name,
                            label: context.tr("full_name"),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 3,
                            child: IconButton(
                              icon: Icon(Icons.info_outline, color: Colors.red),
                              onPressed: () {
                                context.showSnackbar(
                                  context
                                      .tr("request_support_to_update_profile"),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      // CustomDropdown(
                      //   label: context.tr("designation_title"),
                      //   hint: Text(
                      //     context.tr("select_designation"),
                      //     style: TextStyle(
                      //       fontSize: 14,
                      //       color: grey,
                      //     ),
                      //   ),
                      //   width: context.width - 40,
                      //   items: [
                      //     context.tr("senior_journalist"),
                      //     context.tr("journalist"),
                      //     context.tr("senior_anchor"),
                      //     context.tr("anchor"),
                      //   ],
                      //   selectedValue: null,
                      //   onChange: (value) {},
                      // ),
                      Stack(
                        children: [
                          CustomTextfield(
                            disabled: true,
                            defaultValue: storedUser.email,
                            label: context.tr("email_address"),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 3,
                            child: IconButton(
                              icon: Icon(Icons.info_outline, color: Colors.red),
                              onPressed: () {
                                context.showSnackbar(
                                  context
                                      .tr("request_support_to_update_profile"),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          CustomTextfield(
                            disabled: true,
                            defaultValue: storedUser.phone,
                            label: context.tr("mobile_number"),
                            keyboardType: TextInputType.number,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 3,
                            child: IconButton(
                              icon: Icon(Icons.info_outline, color: Colors.red),
                              onPressed: () {
                                context.showSnackbar(
                                  context
                                      .tr("request_support_to_update_profile"),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Text(
                      //       context.tr("social_media_profiles"),
                      //       style: TextStyle(
                      //         fontSize: 12,
                      //         fontWeight: FontWeight.w500,
                      //         color: primaryBlue,
                      //       ),
                      //     ),
                      //     const SizedBox(height: 10),
                      //     CustomTextfield(
                      //       prefixIcon: Icon(
                      //         Icons.facebook,
                      //         color: grey,
                      //       ),
                      //     ),
                      //     const SizedBox(height: 15),
                      //     CustomTextfield(
                      //       prefixIcon: Container(
                      //         padding: EdgeInsets.all(9),
                      //         height: 15,
                      //         width: 15,
                      //         child: Image.asset(
                      //           'assets/icons/twitter.png',
                      //           fit: BoxFit.contain,
                      //           color: grey,
                      //         ),
                      //       ),
                      //     ),
                      //     const SizedBox(height: 15),
                      //     CustomTextfield(
                      //       prefixIcon: Container(
                      //         padding: EdgeInsets.all(9),
                      //         height: 15,
                      //         width: 15,
                      //         child: Image.asset(
                      //           'assets/icons/instagram.png',
                      //           fit: BoxFit.contain,
                      //           color: grey,
                      //         ),
                      //       ),
                      //     ),
                      //     const SizedBox(height: 15),
                      //     CustomTextfield(
                      //       prefixIcon: Icon(
                      //         Icons.tiktok_rounded,
                      //         color: grey,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 10),
                      // CustomButton(
                      //   height: 45,
                      //   text: context.tr("update"),
                      // ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
