import 'package:flutter/material.dart';
import 'package:pchr/constants/app_colors.dart';
import 'package:pchr/utils/localization_utils.dart';

enum AuthFieldType {
  name(
    label: 'Name',
    trLabel: 'name',
    icon: Icons.person_outline,
  ),
  email(
    label: 'Email',
    trLabel: 'email',
    icon: Icons.email_outlined,
  ),
  password(
    label: 'Password',
    trLabel: 'password',
    icon: Icons.lock,
  ),
  confirmPassword(
    label: 'Confirm password',
    trLabel: 'confirm_password',
    icon: Icons.check_box_outlined,
  ),
  phoneNumber(
    label: 'Phone Number',
    trLabel: 'phone_number',
    icon: Icons.call,
  );

  final String label;
  final String trLabel;
  final IconData icon;

  const AuthFieldType(
      {required this.label, required this.trLabel, required this.icon});
}

class AuthTextfield extends StatelessWidget {
  final String? label;
  final AuthFieldType type;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  AuthTextfield({
    super.key,
    this.label,
    this.controller,
    this.validator,
    required this.type,
  });

  final ValueNotifier<bool> _passwordVisible = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _passwordVisible,
      builder: (context, passwordVisible, child) {
        return TextFormField(
          controller: controller,
          validator: validator ??
              (value) {
                switch (type) {
                  case AuthFieldType.name:
                    final bool isValidname = value != null && value.isNotEmpty;
                    return isValidname
                        ? null
                        : context.tr("enter_valid_username");
                  case AuthFieldType.phoneNumber:
                    return null;
                    final bool isValidnumber =
                        value != null && value.isNotEmpty;
                    return isValidnumber
                        ? null
                        : context.tr("enter_valid_number");
                  case AuthFieldType.email:
                    RegExp regex =
                        RegExp(r'^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,}$');
                    final bool isValidEmail = regex.hasMatch(value ?? '');
                    return isValidEmail
                        ? null
                        : context.tr("enter_valid_email");
                  case AuthFieldType.password:
                    if (value!.length < 6) {
                      return context.tr("password_atleast_6_characters");
                    } else {
                      return null;
                    }
                  case AuthFieldType.confirmPassword:
                    if (value!.length < 6) {
                      return context.tr("password_atleast_6_characters");
                    } else {
                      return null;
                    }
                }
              },
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          obscureText: type == AuthFieldType.password ||
                  type == AuthFieldType.confirmPassword
              ? !passwordVisible
              : false,
          decoration: InputDecoration(
            filled: true,
            fillColor: lightGrey,
            labelText: label ?? context.tr(type.trLabel),
            suffixIcon: type == AuthFieldType.password ||
                    type == AuthFieldType.confirmPassword
                ? IconButton(
                    onPressed: () {
                      _passwordVisible.value = !_passwordVisible.value;
                    },
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    color: darkGrey,
                  )
                : SizedBox(),
            labelStyle: TextStyle(
              color: darkGrey,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            prefixIcon: Icon(
              type.icon,
              color: darkGrey,
              size: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        );
      },
    );
  }
}
