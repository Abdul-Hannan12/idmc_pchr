// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pchr/constants/app_colors.dart';
import 'package:pchr/screens/auth/login/login_screen.dart';
import 'package:pchr/screens/auth/provider/auth_provider.dart';
import 'package:pchr/utils/dialog_utils.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:pchr/utils/nav_utils.dart';
import 'package:pchr/utils/size_utils.dart';
import 'package:pchr/widgets/auth_textfield.dart';
import 'package:pchr/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
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
                        context.tr("reset_password"),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: black,
                        ),
                      ),
                      SizedBox(height: context.percentHeight(7)),
                      AuthTextfield(
                        controller: passwordController,
                        type: AuthFieldType.password,
                        label: context.tr("enter_your_password"),
                      ),
                      SizedBox(height: context.percentHeight(4)),
                      CustomButton(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            context.showLoading();
                            final Map<String, dynamic> data = {
                              "email": widget.email,
                              "new_password": passwordController.text.trim(),
                            };
                            final authProvider = context.read<AuthProvider>();
                            bool success =
                                await authProvider.resetPassword(context, data);
                            if (success) {
                              context.pop();
                              context.navigateTo(
                                LoginScreen(),
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
