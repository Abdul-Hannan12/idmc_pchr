// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pchr/constants/app_colors.dart';
import 'package:pchr/screens/auth/additional_details.dart';
import 'package:pchr/screens/auth/provider/auth_provider.dart';
import 'package:pchr/screens/verification/otp_verification/widgets/otp_field.dart';
import 'package:pchr/screens/verification/provider/verification_provider.dart';
import 'package:pchr/utils/dialog_utils.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:pchr/utils/nav_utils.dart';
import 'package:pchr/utils/size_utils.dart';
import 'package:pchr/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import '../../auth/reset_password/reset_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final bool resend, passwordReset;
  const OtpVerificationScreen({
    super.key,
    required this.email,
    this.resend = false,
    this.passwordReset = false,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final ValueNotifier<bool> otpFilled = ValueNotifier(false);
  final otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted && widget.resend) {
        context.read<VerificationProvider>().resendOtp({"email": widget.email});
      }
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

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
                                context.tr("account_verification"),
                                style: TextStyle(
                                  color: black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                context
                                    .tr("sent_code_to_email_enter_code_below"),
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
                    SizedBox(height: context.percentHeight(5)),
                    Image.asset(
                      width: 101,
                      fit: BoxFit.fitWidth,
                      'assets/icons/envelope.png',
                    ),
                    SizedBox(height: context.percentHeight(5)),
                    OtpField(
                      controller: otpController,
                      onChanged: (value) {
                        if (value.length == 4) {
                          otpFilled.value = true;
                        } else {
                          otpFilled.value = false;
                        }
                      },
                    ),
                    SizedBox(height: context.percentHeight(8.7)),
                    ValueListenableBuilder(
                      valueListenable: otpFilled,
                      builder: (context, value, child) {
                        return CustomButton(
                          disabled: !value,
                          onTap: () async {
                            context.showLoading();
                            final data = {
                              "email": widget.email,
                              "otp": otpController.text.trim(),
                            };
                            final bool success = await context
                                .read<VerificationProvider>()
                                .verifyOtp(data);
                            if (success) {
                              context.pop();
                              context.navigateAndRemoveCurrentPage(
                                widget.passwordReset
                                    ? ResetPasswordScreen(email: widget.email)
                                    : ChangeNotifierProvider<AuthProvider>(
                                        create: (context) => AuthProvider(),
                                        builder: (context, child) {
                                          return AdditionalDetailsScreen(
                                            email: widget.email,
                                          );
                                        },
                                      ),
                              );
                            } else {
                              context.pop();
                            }
                          },
                          text: context.tr("verify_account"),
                        );
                      },
                    ),
                    SizedBox(height: context.percentHeight(3.75)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.tr("didn't_receive_code_yet?"),
                          style: TextStyle(
                            color: darkGrey,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            context.showLoading();
                            final Map<String, dynamic> data = {
                              "email": widget.email,
                            };
                            final bool success = await context
                                .read<VerificationProvider>()
                                .resendOtp(data);
                            if (success) {
                              context.pop();
                            } else {
                              context.pop();
                            }
                          },
                          child: Text(
                            context.tr("resend"),
                            style: TextStyle(
                              color: primaryBlue,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
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
