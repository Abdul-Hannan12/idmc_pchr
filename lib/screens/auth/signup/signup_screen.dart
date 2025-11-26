// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pchr/constants/app_colors.dart';
import 'package:pchr/screens/auth/login/login_screen.dart';
import 'package:pchr/screens/auth/provider/auth_provider.dart';
import 'package:pchr/screens/verification/otp_verification/otp_verification_screen.dart';
import 'package:pchr/utils/dialog_utils.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:pchr/utils/nav_utils.dart';
import 'package:pchr/utils/size_utils.dart';
import 'package:pchr/widgets/auth_textfield.dart';
import 'package:pchr/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                          context.tr("create_account"),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                            color: black,
                          ),
                        ),
                        SizedBox(height: context.percentHeight(7)),
                        AuthTextfield(
                          controller: usernameController,
                          type: AuthFieldType.name,
                        ),
                        SizedBox(height: 18),
                        AuthTextfield(
                          controller: phoneController,
                          type: AuthFieldType.phoneNumber,
                        ),
                        SizedBox(height: 18),
                        AuthTextfield(
                          controller: emailController,
                          type: AuthFieldType.email,
                        ),
                        SizedBox(height: 18),
                        AuthTextfield(
                          controller: passwordController,
                          type: AuthFieldType.password,
                        ),
                        SizedBox(height: 18),
                        AuthTextfield(
                          controller: confirmPasswordController,
                          type: AuthFieldType.confirmPassword,
                          validator: (value) {
                            if (value.trim() !=
                                passwordController.text.trim()) {
                              return context
                                  .tr("confirm_password_must_be_same");
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: context.percentHeight(5)),
                        CustomButton(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              context.showLoading();
                              final Map<String, dynamic> data = {
                                "name": usernameController.text.trim(),
                                "phone": phoneController.text.trim(),
                                "email": emailController.text.trim(),
                                "password": passwordController.text.trim(),
                              };
                              bool success = await context
                                  .read<AuthProvider>()
                                  .signUp(context, data);
                              if (success) {
                                context.pop();
                                context.navigateTo(OtpVerificationScreen(
                                  email: emailController.text.trim(),
                                ));
                              } else {
                                context.pop();
                              }
                            }
                          },
                          text: context.tr("signup"),
                        ),
                        // SizedBox(height: context.percentHeight(4)),
                        // Row(
                        //   children: [
                        //     Expanded(child: Divider()),
                        //     Text(
                        //       context.tr("or_signup_with"),
                        //       style: TextStyle(
                        //         color: primaryOrange,
                        //         fontSize: 15,
                        //         fontWeight: FontWeight.w400,
                        //       ),
                        //     ),
                        //     Expanded(child: Divider()),
                        //   ],
                        // ),
                        // SizedBox(height: context.percentHeight(6)),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     SocialAuthButton(SocialAuthType.facebook),
                        //     SocialAuthButton(SocialAuthType.google),
                        //     SocialAuthButton(SocialAuthType.apple),
                        //   ],
                        // ),
                        SizedBox(height: context.percentHeight(3)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              context.tr("already_have_account?"),
                              style: TextStyle(
                                color: black,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.navigateAndRemoveCurrentPage(
                                  LoginScreen(),
                                );
                              },
                              child: Text(
                                context.tr("login_now"),
                                style: TextStyle(
                                  color: primaryBlue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 60),
                      ],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
