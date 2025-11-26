// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pchr/constants/app_colors.dart';
import 'package:pchr/screens/auth/forgot_password/forgot_password_screen.dart';
import 'package:pchr/screens/auth/provider/auth_provider.dart';
import 'package:pchr/screens/dashboard/dashboard.dart';
import 'package:pchr/screens/auth/signup/signup_screen.dart';
import 'package:pchr/utils/dialog_utils.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:pchr/utils/nav_utils.dart';
import 'package:pchr/utils/size_utils.dart';
import 'package:pchr/widgets/auth_textfield.dart';
import 'package:pchr/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                        context.tr("login"),
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
                      SizedBox(height: 18),
                      AuthTextfield(
                        controller: passwordController,
                        type: AuthFieldType.password,
                        label: context.tr("enter_your_password"),
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            context.navigateTo(ForgotPasswordScreen());
                          },
                          child: Text(
                            context.tr("forgot_password?"),
                            style: TextStyle(
                              color: primaryOrange,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: context.percentHeight(4)),
                      CustomButton(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            context.showLoading();
                            final Map<String, dynamic> data = {
                              "email": emailController.text.trim(),
                              "password": passwordController.text.trim(),
                            };
                            final authProvider = context.read<AuthProvider>();
                            bool success =
                                await authProvider.login(context, data);
                            if (success) {
                              context.pop();
                              context.navigateTo(Dashboard());
                            } else {
                              context.pop();
                              if (authProvider.loginErrorScreen != null) {
                                context
                                    .navigateTo(authProvider.loginErrorScreen!);
                              }
                            }
                          }
                        },
                        text: context.tr("login"),
                      ),
                      SizedBox(height: context.percentHeight(6)),
                      // Row(
                      //   children: [
                      //     Expanded(child: Divider()),
                      //     Text(
                      //       context.tr("or_login_with"),
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
                      // SizedBox(height: context.percentHeight(4)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.tr("dont_have_account?"),
                            style: TextStyle(
                              color: black,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context
                                  .navigateAndRemoveCurrentPage(SignupScreen());
                            },
                            child: Text(
                              context.tr("register_now"),
                              style: TextStyle(
                                color: primaryBlue,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
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
