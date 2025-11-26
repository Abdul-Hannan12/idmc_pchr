import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:pchr/utils/size_utils.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/file_utils.dart';
import '../provider/form_provider.dart';

class UploadEvidenceField extends StatelessWidget {
  const UploadEvidenceField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr("evidence_images"),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: primaryBlue,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: context.percentHeight(10),
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 7,
                color: Colors.black.withValues(alpha: 0.08),
              ),
            ],
          ),
          child: Selector<FormProvider, List<File>>(
            selector: (context, provider) => provider.evidenceImages,
            builder: (context, files, child) {
              return Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          width: context.percentWidth(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: primaryOrange),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              files[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(width: 10),
                      itemCount: files.length,
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () async {
                      List<File>? pickedFiles = await pickImages();
                      if (pickedFiles != null) {
                        // ignore: use_build_context_synchronously
                        context.read<FormProvider>().evidenceImages =
                            pickedFiles;
                      }
                    },
                    child: Container(
                      width: context.percentWidth(15),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 1),
                            blurRadius: 7,
                            color: Colors.black.withValues(alpha: 0.08),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          files.isEmpty ? Icons.file_upload : Icons.refresh,
                          color: black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
