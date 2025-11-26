// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pchr/screens/auth/login/login_screen.dart';
import 'package:pchr/screens/auth/provider/auth_provider.dart';
import 'package:pchr/widgets/upload_documents_field.dart';
import 'package:pchr/utils/dialog_utils.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:pchr/utils/nav_utils.dart';
import 'package:pchr/utils/size_utils.dart';
import 'package:pchr/widgets/custom_appbar.dart';
import 'package:pchr/widgets/custom_button.dart';
import 'package:pchr/widgets/custom_date_picker.dart';
import 'package:pchr/widgets/custom_dropdown.dart';
import 'package:pchr/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';

class AdditionalDetailsScreen extends StatefulWidget {
  final String email;
  const AdditionalDetailsScreen({super.key, required this.email});

  @override
  State<AdditionalDetailsScreen> createState() =>
      _AdditionalDetailsScreenState();
}

class _AdditionalDetailsScreenState extends State<AdditionalDetailsScreen> {
  final fatherNameController = TextEditingController();
  final dobController = TextEditingController();
  final placeOfBirthController = TextEditingController();
  final addressController = TextEditingController();
  final postalCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _documentsKey = GlobalKey<UploadDocumentsFieldState>();

  @override
  void dispose() {
    fatherNameController.dispose();
    dobController.dispose();
    placeOfBirthController.dispose();
    addressController.dispose();
    postalCodeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<AuthProvider>().getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomAppbar(
                titleText: context.tr("user_details"),
                subtitleText:
                    context.tr("profile_information_about_your_account"),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 15,
                      children: [
                        CustomTextfield(
                          label: context.tr("father_name"),
                          controller: fatherNameController,
                        ),
                        CustomDatePicker(
                          label: context.tr("date_of_birth"),
                          controller: dobController,
                        ),
                        Selector<AuthProvider, String?>(
                          selector: (context, provider) => provider.gender,
                          builder: (context, gender, child) {
                            return CustomDropdown(
                              label: context.tr("gender"),
                              hint: Text(
                                context.tr("gender"),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: grey,
                                ),
                              ),
                              width: context.width - 40,
                              items: [
                                context.tr("male"),
                                context.tr("female"),
                              ],
                              selectedValue: gender,
                              onChange: (value) {
                                context.read<AuthProvider>().gender = value;
                              },
                            );
                          },
                        ),
                        CustomTextfield(
                          label: context.tr("place_of_birth"),
                          controller: placeOfBirthController,
                        ),
                        CustomTextfield(
                          label: context.tr("address"),
                          controller: addressController,
                        ),
                        CustomTextfield(
                          label: context.tr("postal_code"),
                          controller: postalCodeController,
                          keyboardType: TextInputType.number,
                        ),
                        Selector<AuthProvider, String?>(
                          selector: (context, provider) => provider.designation,
                          builder: (context, designation, child) {
                            return CustomDropdown(
                              label: context.tr("designation_title"),
                              hint: Text(
                                context.tr("select_designation"),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: grey,
                                ),
                              ),
                              width: context.width - 40,
                              items: [
                                context.tr("senior_journalist"),
                                context.tr("journalist"),
                                context.tr("senior_anchor"),
                                context.tr("anchor"),
                                context.tr("media_worker"),
                                context.tr("other"),
                              ],
                              selectedValue: designation,
                              onChange: (value) {
                                context.read<AuthProvider>().designation =
                                    value;
                              },
                            );
                          },
                        ),
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return CustomDropdown(
                              label: context.tr("province"),
                              hint: Text(
                                context.tr("province"),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: grey,
                                ),
                              ),
                              width: context.width - 40,
                              items: authProvider.provinceIds,
                              labels: authProvider.provinces,
                              selectedValue: authProvider.selectedProvince,
                              onChange: (value) {
                                authProvider.selectedProvince = value;
                                authProvider.districts = <String>[];
                                authProvider.selectedDistrict = null;
                                authProvider.cities = <String>[];
                                authProvider.selectedCity = null;
                                context
                                    .read<AuthProvider>()
                                    .getDistricts(value!);
                              },
                            );
                          },
                        ),
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return CustomDropdown(
                              label: context.tr("district"),
                              hint: Text(
                                context.tr("district"),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: grey,
                                ),
                              ),
                              width: context.width - 40,
                              items: authProvider.districtIds,
                              labels: authProvider.districts,
                              selectedValue: authProvider.selectedDistrict,
                              onChange: (value) {
                                authProvider.selectedDistrict = value;
                                authProvider.cities = <String>[];
                                authProvider.selectedCity = null;
                                context.read<AuthProvider>().getCities(value!);
                              },
                            );
                          },
                        ),
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return CustomDropdown(
                              label: context.tr("city"),
                              hint: Text(
                                context.tr("city"),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: grey,
                                ),
                              ),
                              width: context.width - 40,
                              items: authProvider.cityIds,
                              labels: authProvider.cities,
                              selectedValue: authProvider.selectedCity,
                              onChange: (value) {
                                authProvider.selectedCity = value;
                              },
                            );
                          },
                        ),
                        UploadDocumentsField(
                          key: _documentsKey,
                          validator: (values) {
                            if (values.isEmpty ||
                                values.any((val) => val == null)) {
                              return 'Documents are Required';
                            } else if (values.any(
                                (val) => val!.lengthSync() > 2048 * 1024)) {
                              return 'File size should not exceed 2048 KB';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomButton(
                          onTap: () async {
                            if (_formKey.currentState!.validate() &&
                                _documentsKey.currentState!.validate()) {
                              context.showLoading();
                              final authProvider = context.read<AuthProvider>();
                              final Map<String, dynamic> data = {
                                "email": widget.email,
                                "father_name": fatherNameController.text.trim(),
                                "date_of_birth": dobController.text.trim(),
                                "gender": authProvider.gender,
                                "place_of_birth":
                                    placeOfBirthController.text.trim(),
                                "address": addressController.text.trim(),
                                "postal_code": postalCodeController.text.trim(),
                                "designation": authProvider.designation,
                                "province": authProvider.selectedProvince,
                                "district_id": authProvider.selectedDistrict,
                                "tehsil_id": authProvider.selectedCity,
                              };
                              final List<Map<String, File?>> files = [
                                {"cnic_front": authProvider.cnicFront},
                                {"cnic_back": authProvider.cnicBack},
                                {"press_card": authProvider.serviceCard},
                              ];
                              bool success = await context
                                  .read<AuthProvider>()
                                  .registerStepTwo(data, files);
                              if (success) {
                                context.pop();
                                context.navigateTo(LoginScreen());
                              } else {
                                context.pop();
                              }
                            }
                          },
                          height: 45,
                          text: context.tr("submit"),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
