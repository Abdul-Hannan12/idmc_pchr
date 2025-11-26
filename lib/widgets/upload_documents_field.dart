// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pchr/screens/auth/provider/auth_provider.dart';
import 'package:pchr/utils/file_utils.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:pchr/utils/size_utils.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';

typedef DocumentsFieldValidator = String? Function(List<File?> values);

class UploadDocumentsField extends StatefulWidget {
  final DocumentsFieldValidator? validator;
  const UploadDocumentsField({super.key, this.validator});

  @override
  State<UploadDocumentsField> createState() => UploadDocumentsFieldState();
}

class UploadDocumentsFieldState extends State<UploadDocumentsField> {
  bool hasError = false;
  String? _errorText;

  bool validate() {
    setState(() {
      _validate();
    });
    return !hasError;
  }

  void _validate() {
    if (widget.validator != null) {
      final authProvider = context.read<AuthProvider>();
      String? validatorText = widget.validator!(
        [
          authProvider.cnicFront,
          authProvider.cnicBack,
          authProvider.serviceCard
        ],
      );
      _errorText = validatorText;
      hasError = validatorText != null;
    } else {
      hasError = false;
      _errorText = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr("upload_documents"),
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
          child: Selector<AuthProvider, Map<String, File?>>(
            selector: (context, provider) => {
              'cnicFront': provider.cnicFront,
              'cnicBack': provider.cnicBack,
              'serviceCard': provider.serviceCard,
            },
            builder: (context, filesMap, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _cardPickItem(context, DocumentType.cnicFront, filesMap),
                  _cardPickItem(context, DocumentType.cnicBack, filesMap),
                  _cardPickItem(context, DocumentType.serviceCard, filesMap),
                ],
              );
            },
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 2, left: 5),
            child: Text(
              _errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 10),
            ),
          ),
      ],
    );
  }

  Widget _cardPickItem(
    BuildContext context,
    DocumentType type,
    Map<String, File?> filesMap,
  ) {
    return InkWell(
      onTap: () async {
        File? pickedFile = await pickImage(source: ImageSource.gallery);
        final authProvider = context.read<AuthProvider>();
        switch (type) {
          case DocumentType.cnicFront:
            authProvider.cnicFront = pickedFile;
          case DocumentType.cnicBack:
            authProvider.cnicBack = pickedFile;
          case DocumentType.serviceCard:
            authProvider.serviceCard = pickedFile;
        }
        validate();
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: context.percentWidth(24),
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
        child: filesMap[type.key] != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  filesMap[type.key]!,
                  fit: BoxFit.cover,
                ),
              )
            : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      type.name,
                      style: TextStyle(
                        color: primaryBlue,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Icon(
                      Icons.add,
                      color: darkGrey,
                      size: 12,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

enum DocumentType {
  cnicFront('cnicFront', 'CNIC Front'),
  cnicBack('cnicBack', 'CNIC Back'),
  serviceCard('serviceCard', 'Service Card');

  final String key;
  final String name;

  const DocumentType(this.key, this.name);
}
