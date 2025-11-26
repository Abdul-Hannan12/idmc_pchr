// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pchr/constants/app_urls.dart';
import 'package:pchr/data/network/network_api_services.dart';
import 'package:pchr/utils/dialog_utils.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:pchr/utils/nav_utils.dart';
import 'package:pchr/widgets/custom_appbar.dart';
import 'package:pchr/widgets/custom_button.dart';
import 'package:pchr/widgets/custom_textfield.dart';

import '../../constants/hive_boxes.dart';

class OnlineSupportScreen extends StatefulWidget {
  const OnlineSupportScreen({super.key});

  @override
  State<OnlineSupportScreen> createState() => _OnlineSupportScreenState();
}

class _OnlineSupportScreenState extends State<OnlineSupportScreen> {
  final subjectController = TextEditingController();
  final descController = TextEditingController();

  @override
  void dispose() {
    subjectController.dispose();
    descController.dispose();
    return super.dispose();
  }

  Future<bool> sendSupportMessage() async {
    context.showLoading();
    try {
      await NetworkApiServices().postApi(
        onlineSupportApiUrl,
        {
          "subject": subjectController.text.trim(),
          "description": descController.text.trim(),
        },
        isAuth: true,
        token: storedUser.token,
      );
      context.pop();
      return true;
    } catch (e) {
      context.showSnackbar(e.toString());
      context.pop();
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            CustomAppbar(
              titleText: context.tr("online_support"),
              subtitleText: context.tr("reach_out_with_your_inquiries"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextfield(
                    controller: subjectController,
                    label: context.tr("add_subject"),
                  ),
                  const SizedBox(height: 20),
                  CustomTextfield(
                    controller: descController,
                    label: context.tr("add_description"),
                    isTextArea: true,
                  ),
                  const SizedBox(height: 25),
                  CustomButton(
                    onTap: () async {
                      bool success = await sendSupportMessage();
                      if (success) {
                        context.pop();
                      }
                    },
                    height: 45,
                    text: context.tr("submit"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
