// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pchr/constants/app_colors.dart';
import 'package:pchr/screens/auth/provider/auth_provider.dart';
import 'package:pchr/screens/verification/otp_verification/otp_verification_screen.dart';
import 'package:pchr/utils/dialog_utils.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:pchr/utils/nav_utils.dart';
import 'package:pchr/utils/size_utils.dart';
import 'package:pchr/widgets/auth_textfield.dart';
import 'package:pchr/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: ChangeNotifierProvider<AuthProvider>(
              create: (context) => AuthProvider(),
              builder: (context, child) {
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: context.percentHeight(7)),
                      Text(
                        context.tr("reset_password"),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: black,
                        ),
                      ),
                      SizedBox(height: context.percentHeight(7)),
                      AuthTextfield(
                        controller: emailController,
                        type: AuthFieldType.email,
                        label: context.tr("enter_your_email"),
                      ),
                      SizedBox(height: context.percentHeight(4)),
                      CustomButton(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            context.showLoading();
                            final Map<String, dynamic> data = {
                              "email": emailController.text.trim(),
                            };
                            final authProvider = context.read<AuthProvider>();
                            bool success = await authProvider.forgotPassword(
                                context, data);
                            if (success) {
                              context.pop();
                              context.navigateTo(
                                OtpVerificationScreen(
                                  email: emailController.text.trim(),
                                  passwordReset: true,
                                ),
                              );
                            } else {
                              context.pop();
                            }
                          }
                        },
                        text: context.tr("submit"),
                      ),
                      SizedBox(height: context.percentHeight(5)),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
