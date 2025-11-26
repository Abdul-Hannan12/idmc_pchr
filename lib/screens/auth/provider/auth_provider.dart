// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pchr/constants/app_urls.dart';
import 'package:pchr/data/network/network_api_services.dart';
import 'package:pchr/models/user/user.dart';
import 'package:pchr/screens/auth/additional_details.dart';
import 'package:pchr/screens/verification/otp_verification/otp_verification_screen.dart';
import 'package:pchr/screens/verification/provider/verification_provider.dart';
import 'package:pchr/screens/verification/verification_status/verification_status.dart';
import 'package:pchr/utils/dialog_utils.dart';
import 'package:provider/provider.dart';

import '../../../constants/hive_boxes.dart';

class AuthProvider extends ChangeNotifier {
  final _api = NetworkApiServices();

  Widget? loginErrorScreen;

  String? _gender;
  String? get gender => _gender;
  set gender(gender) {
    _gender = gender;
    notifyListeners();
  }

  List<String> _provinces = [];
  List<String> get provinces => _provinces;
  set provinces(provinces) {
    _provinces = provinces;
    notifyListeners();
  }

  List<String> _provinceIds = [];
  List<String> get provinceIds => _provinceIds;
  set provinceIds(provinceIds) {
    _provinceIds = provinceIds;
    notifyListeners();
  }

  List<String> _cities = [];
  List<String> get cities => _cities;
  set cities(cities) {
    _cities = cities;
    notifyListeners();
  }

  List<String> _districts = [];
  List<String> get districts => _districts;
  set districts(districts) {
    _districts = districts;
    notifyListeners();
  }

  List<String> _cityIds = [];
  List<String> get cityIds => _cityIds;
  set cityIds(cityIds) {
    _cityIds = cityIds;
    notifyListeners();
  }

  List<String> _districtIds = [];
  List<String> get districtIds => _districtIds;
  set districtIds(districtIds) {
    _districtIds = districtIds;
    notifyListeners();
  }

  String? _designation;
  String? get designation => _designation;
  set designation(designation) {
    _designation = designation;
    notifyListeners();
  }

  String? _selectedProvince;
  String? get selectedProvince => _selectedProvince;
  set selectedProvince(String? province) {
    _selectedProvince = province;
    notifyListeners();
  }

  String? _selectedCity;
  String? get selectedCity => _selectedCity;
  set selectedCity(String? city) {
    _selectedCity = city;
    notifyListeners();
  }

  String? _selectedDistrict;
  String? get selectedDistrict => _selectedDistrict;
  set selectedDistrict(String? district) {
    _selectedDistrict = district;
    notifyListeners();
  }

  File? _cnicFront;
  File? get cnicFront => _cnicFront;
  set cnicFront(File? file) {
    _cnicFront = file;
    notifyListeners();
  }

  File? _cnicBack;
  File? get cnicBack => _cnicBack;
  set cnicBack(File? file) {
    _cnicBack = file;
    notifyListeners();
  }

  File? _serviceCard;
  File? get serviceCard => _serviceCard;
  set serviceCard(File? file) {
    _serviceCard = file;
    notifyListeners();
  }

  Future<bool> signUp(BuildContext context, Map<String, dynamic> data) async {
    try {
      await _api.postApi(signupApiUrl, data);
      return true;
    } catch (e) {
      context.showSnackbar(e.toString());
      return false;
    }
  }

  Future<bool> login(BuildContext context, Map<String, dynamic> data) async {
    try {
      Map<String, dynamic> res = await _api.postApi(loginApiUrl, data);
      res['user']['token'] = res['token'];
      res['user']['is_approved'] = res['is_approved'];
      final user = User.fromJson(res['user']);
      await userBox.put(user.id, user);
      if (!(user.isApproved ?? false)) {
        loginErrorScreen = ChangeNotifierProvider<VerificationProvider>(
          create: (context) => VerificationProvider(),
          builder: (context, child) {
            return VerificationStatusScreen();
          },
        );
        return false;
      }
      loginErrorScreen = null;
      return true;
    } catch (e) {
      context.showSnackbar("$e");
      if (e.toString().contains('verify your email')) {
        loginErrorScreen = ChangeNotifierProvider<VerificationProvider>(
          create: (context) => VerificationProvider(),
          builder: (context, child) {
            return OtpVerificationScreen(
              email: data['email'],
              resend: true,
            );
          },
        );
      } else if (e.toString().contains('details not found')) {
        loginErrorScreen = ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
          builder: (context, child) {
            return AdditionalDetailsScreen(email: data['email']);
          },
        );
      } else {
        loginErrorScreen = null;
      }
      return false;
    }
  }

  Future getProvinces() async {
    try {
      final res = await _api.getApi(getProvincesApiUrl);
      List<String> resProvinceIds = [];
      List<String> resProvinceNames = [];

      for (var i in res) {
        resProvinceIds.add("${i['id']}");
        resProvinceNames.add("${i['name']}");
      }

      provinceIds = resProvinceIds;
      provinces = resProvinceNames;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> getCities(String districtId) async {
    try {
      final res = await _api.getApi(getCitiesApiUrl(districtId));
      List<String> resCities = [];
      List<String> resCityIds = [];

      for (var i in res) {
        resCityIds.add("${i['id']}");
        resCities.add("${i['name']}");
      }

      cityIds = resCityIds;
      cities = resCities;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> getDistricts(String provinceId) async {
    try {
      final res = await _api.getApi(getDistrictsApiUrl(provinceId));
      List<String> resDistricts = [];
      List<String> resDistrictIds = [];

      for (var i in res) {
        resDistrictIds.add("${i['id']}");
        resDistricts.add("${i['name']}");
      }

      districtIds = resDistrictIds;
      districts = resDistricts;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> registerStepTwo(
    Map<String, dynamic> data,
    List<Map<String, File?>> files,
  ) async {
    try {
      await _api.postApi(registerStepTwoApiUrl, data, files: files);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> forgotPassword(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    try {
      await _api.postApi(forgotPasswordApiUrl, data);
      return true;
    } catch (e) {
      context.showSnackbar(e.toString());
      return false;
    }
  }

  Future<bool> resetPassword(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    try {
      await _api.postApi(resetPasswordApiUrl, data);
      return true;
    } catch (e) {
      context.showSnackbar(e.toString());
      return false;
    }
  }
}
