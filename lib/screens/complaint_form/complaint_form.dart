// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pchr/models/complaint/complaint.dart';
import 'package:pchr/screens/auth/provider/auth_provider.dart';
import 'package:pchr/screens/complaint_form/provider/form_provider.dart';
import 'package:pchr/screens/complaint_form/widgets/uplaod_evidence_field.dart';
import 'package:pchr/utils/dialog_utils.dart';
import 'package:pchr/utils/gps_utils.dart';
import 'package:pchr/utils/localization_utils.dart';
import 'package:pchr/utils/nav_utils.dart';
import 'package:pchr/utils/size_utils.dart';
import 'package:pchr/widgets/custom_appbar.dart';
import 'package:pchr/widgets/custom_button.dart';
import 'package:pchr/widgets/custom_dropdown.dart';
import 'package:pchr/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_urls.dart';
import '../../constants/hive_boxes.dart';
import '../../data/network/network_api_services.dart';

class ComplaintFormScreen extends StatefulWidget {
  final ComplaintCategory complaintType;
  const ComplaintFormScreen({super.key, required this.complaintType});

  @override
  State<ComplaintFormScreen> createState() => _ComplaintFormScreenState();
}

class _ComplaintFormScreenState extends State<ComplaintFormScreen> {
  final instituteController = TextEditingController();
  final addressController = TextEditingController();
  final linkController = TextEditingController();
  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    instituteController.dispose();
    addressController.dispose();
    linkController.dispose();
    subjectController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            CustomAppbar(
              titleText: context.tr("report_complaint"),
              subtitleText: context.tr("add_complaint_details"),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        create: (context) => FormProvider(),
                      ),
                      ChangeNotifierProvider(
                        create: (context) => AuthProvider(),
                      ),
                    ],
                    builder: (context, child) {
                      context.read<AuthProvider>().getProvinces();
                      return Form(
                        key: _formKey,
                        child: Column(
                          spacing: 15,
                          children: [
                            FutureBuilder(
                              future: NetworkApiServices().getApi(
                                getComplaintsApiUrl,
                                isAuth: true,
                                token: storedUser.token,
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final complaints = snapshot.data
                                      .map((c) => Complaint.fromMap(c))
                                      .toList();
                                  if (complaints.isEmpty) {
                                    return SizedBox();
                                  }
                                  final complaintIds =
                                      complaints.map((c) => "${c.id}").toList();
                                  final complaintTitles = complaints
                                      .map((c) => "${c.subject}")
                                      .toList();
                                  return Selector<FormProvider, String?>(
                                    selector: (context, provider) =>
                                        provider.followupComplaint,
                                    builder:
                                        (context, followUpComplaint, child) {
                                      return CustomDropdown(
                                        label: context.tr("followup_complaint"),
                                        hint: Text(
                                          context.tr("followup_complaint"),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: grey,
                                          ),
                                        ),
                                        width: context.width - 40,
                                        items: complaintIds,
                                        labels: complaintTitles,
                                        selectedValue: followUpComplaint,
                                        onChange: (value) {
                                          context
                                              .read<FormProvider>()
                                              .followupComplaint = value;
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  return SizedBox();
                                }
                              },
                            ),
                            CustomTextfield(
                              controller: instituteController,
                              label: context.tr("institute_association"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return context.tr("institute_required");
                                }
                                return null;
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
                                    context
                                        .read<AuthProvider>()
                                        .getCities(value!);
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
                            CustomTextfield(
                              controller: addressController,
                              label: context.tr("address"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return context.tr("address_required");
                                }
                                return null;
                              },
                            ),
                            UploadEvidenceField(),
                            CustomTextfield(
                              controller: linkController,
                              label: context.tr("link"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return context.tr("link_required");
                                }
                                final urlPattern =
                                    r'^(https?:\/\/)?([\w\-]+(\.[\w\-]+)+)(\/[\w\-.\/?%&=]*)?$';
                                final regex = RegExp(urlPattern);
                                if (!regex.hasMatch(value)) {
                                  return context.tr("link_must_be_valid");
                                }
                                return null;
                              },
                            ),
                            CustomTextfield(
                              controller: subjectController,
                              label: context.tr("subject_line"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return context.tr("subject_required");
                                }
                                return null;
                              },
                            ),
                            CustomTextfield(
                              controller: descriptionController,
                              label: context.tr("complaint_desc"),
                              isTextArea: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return context.tr("desc_required");
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            CustomButton(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  final formProvider =
                                      context.read<FormProvider>();
                                  final authProvider =
                                      context.read<AuthProvider>();
                                  context.showLoading();
                                  Position? pos = await getLocation();
                                  final Map<String, dynamic> data = {
                                    if (formProvider.followupComplaint != null)
                                      "previous_complaint_id":
                                          formProvider.followupComplaint,
                                    "category": widget.complaintType.key,
                                    "institution":
                                        instituteController.text.trim(),
                                    "address": addressController.text.trim(),
                                    "province_id":
                                        authProvider.selectedProvince,
                                    "district_id":
                                        authProvider.selectedDistrict,
                                    "tehsil_id": authProvider.selectedCity,
                                    "link": linkController.text.trim(),
                                    "subject": subjectController.text.trim(),
                                    "description":
                                        descriptionController.text.trim(),
                                    "latitude": pos?.latitude,
                                    "longitude": pos?.longitude,
                                  };
                                  final List<Map<String, File>> files =
                                      formProvider.evidenceImages
                                          .map(
                                            (file) => {
                                              file.path
                                                  .split('/')
                                                  .last
                                                  .split('.')
                                                  .first: file
                                            },
                                          )
                                          .toList();
                                  bool success = await formProvider
                                      .addComplaint(context, data, files);
                                  if (success) {
                                    context.pop();
                                  }
                                  context.pop();
                                }
                              },
                              height: 45,
                              text: context.tr("submit"),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
