// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pchr/constants/app_urls.dart';
import 'package:pchr/constants/hive_boxes.dart';
import 'package:pchr/utils/dialog_utils.dart';

import '../../../data/network/network_api_services.dart';
import '../../../utils/gps_utils.dart';

class FormProvider extends ChangeNotifier {
  final _api = NetworkApiServices();

  String? _followupComplaint;
  String? get followupComplaint => _followupComplaint;
  set followupComplaint(followupComplaint) {
    _followupComplaint = followupComplaint;
    notifyListeners();
  }

  List<File> _evidenceImages = [];
  List<File> get evidenceImages => _evidenceImages;
  set evidenceImages(List<File> file) {
    _evidenceImages = file;
    notifyListeners();
  }

  List<File> addEvidenceImage(File file) {
    _evidenceImages.add(file);
    notifyListeners();
    return _evidenceImages;
  }

  Future<bool> sendPanicAlert(BuildContext context) async {
    try {
      final Position? location = await getLocation();
      if (location != null) {
        _api.postApi(
          panicAlertApiUrl,
          {
            "latitude": location.latitude,
            "longitude": location.longitude,
          },
          isAuth: true,
          token: storedUser.token,
        );
        context.showSnackbar("Panic Alert Sent!");
        return true;
      }
      return false;
    } catch (e) {
      context.showSnackbar(e.toString());
      return false;
    }
  }

  Future<bool> addComplaint(
    BuildContext context,
    Map<String, dynamic> data,
    List<Map<String, File>> files,
  ) async {
    try {
      await _api.postApi(
        registerComplaintApiUrl,
        data,
        files: files,
        isAuth: true,
        token: storedUser.token,
      );
      context.showSnackbar("Compleint Added Successfully!");
      return true;
    } catch (e) {
      context.showSnackbar(e.toString());
      return false;
    }
  }
}
