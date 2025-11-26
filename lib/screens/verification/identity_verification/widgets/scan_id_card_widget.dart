// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pchr/constants/app_colors.dart';
import 'package:pchr/screens/verification/provider/verification_provider.dart';
import 'package:pchr/utils/file_utils.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:pchr/utils/size_utils.dart';
import 'package:provider/provider.dart';

class ScanIdCardWidget extends StatelessWidget {
  const ScanIdCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.tr("choose_an_option"),
          style: TextStyle(
            color: darkGrey,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: context.percentHeight(3)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: context.percentWidth(10),
          children: [
            InkWell(
              onTap: () async {
                File? id = await pickImage();
                context.read<VerificationProvider>().selectedId = id;
              },
              borderRadius: BorderRadius.circular(10),
              child: Column(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: primaryBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    context.tr("take_a_photo"),
                    style: TextStyle(
                      color: black,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                File? id = await pickImage(source: ImageSource.gallery);
                context.read<VerificationProvider>().selectedId = id;
              },
              borderRadius: BorderRadius.circular(10),
              child: Column(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: primaryBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.perm_media_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    context.tr("upload_from_gallery"),
                    style: TextStyle(
                      color: black,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
