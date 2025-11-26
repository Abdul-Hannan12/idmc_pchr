// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:pchr/constants/app_colors.dart';

enum SocialAuthType {
  facebook('assets/icons/facebook.png'),
  google('assets/icons/google.png'),
  apple('assets/icons/apple.png');

  final String iconPath;

  const SocialAuthType(this.iconPath);
}

class SocialAuthButton extends StatelessWidget {
  final SocialAuthType type;
  const SocialAuthButton(
    this.type, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 65,
        width: 65,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: grey.withAlpha(100),
        ),
        child: Image.asset(
          fit: BoxFit.cover,
          type.iconPath,
        ),
      ),
    );
  }
}
