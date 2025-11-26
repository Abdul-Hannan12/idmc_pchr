import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pchr/constants/app_urls.dart';
import 'package:pchr/constants/hive_boxes.dart';
import 'package:pchr/data/network/network_api_services.dart';

enum VerificationStatus {
  waitingForApproval("Waiting For Approval", Color(0xFF4B03FF)),
  approved("Approved", Color(0xFF14C62F)),
  rejected("Rejected", Color(0xFFC61417));

  final String prettyName;
  final Color color;

  const VerificationStatus(this.prettyName, this.color);

  static VerificationStatus fromString(String status) {
    switch (status) {
      case "waitingForApproval":
        return VerificationStatus.waitingForApproval;
      case "approved":
        return VerificationStatus.approved;
      case "rejected":
        return VerificationStatus.rejected;
      default:
        return VerificationStatus.waitingForApproval;
    }
  }
}

class VerificationProvider extends ChangeNotifier {
  final _api = NetworkApiServices();

  File? _selectedId;

  File? get selectedId => _selectedId;

  set selectedId(File? file) {
    _selectedId = file;
    notifyListeners();
  }

  // API REQEUSTS

  Future<bool> resendOtp(Map<String, dynamic> data) async {
    try {
      await _api.postApi(resendOtpApiUrl, data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> verifyOtp(Map<String, dynamic> data) async {
    try {
      await _api.postApi(otpVerificationApiUrl, data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> verifyId() async {
    try {
      await _api.postApi(
        idVerificationApiUrl,
        {},
        files: _selectedId != null
            ? [
                {"id": _selectedId!}
              ]
            : null,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<VerificationStatus> getVerificationstatus() async {
    final res = await _api.postApi(
      verificationStatusApiUrl,
      {},
      isAuth: true,
      token: storedUser.token,
    );
    if (res['is_approved'] == true) {
      return VerificationStatus.approved;
    } else {
      return VerificationStatus.waitingForApproval;
    }
  }
}
