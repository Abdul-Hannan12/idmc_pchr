import 'package:flutter/material.dart';
import 'package:pchr/constants/hive_boxes.dart';
import 'package:pchr/data/network/network_api_services.dart';

import '../../../constants/app_urls.dart';

class StatsProvider extends ChangeNotifier {
  final _api = NetworkApiServices();

  String? _selectedYear;
  String? get selectedYear => _selectedYear;
  set selectedYear(String? year) {
    _selectedYear = year;
    notifyListeners();
  }

  String? _selectedProvinceName;
  String? get selectedProvinceName => _selectedProvinceName;
  set selectedProvinceName(String? name) {
    _selectedProvinceName = name;
    notifyListeners();
  }

  Map<String, dynamic>? _timeWiseData;
  Map<String, dynamic>? get timeWiseData => _timeWiseData;
  set timeWiseData(Map<String, dynamic>? data) {
    _timeWiseData = data;
    notifyListeners();
  }

  Map<String, dynamic>? _areaWiseData;
  Map<String, dynamic>? get areaWiseData => _areaWiseData;
  set areaWiseData(Map<String, dynamic>? data) {
    _areaWiseData = data;
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

  String? _selectedProvince;
  String? get selectedProvince => _selectedProvince;
  set selectedProvince(String? province) {
    _selectedProvince = province;
    notifyListeners();
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

  Future getTimeWiseStats() async {
    try {
      final res = await _api.getApi(
        getTimeWiseStatsApiUrl(selectedYear),
        isAuth: true,
        token: storedUser.token,
      );
      try {
        timeWiseData = {...res["stats"]};
      } catch (e) {
        print(e);
        timeWiseData = null;
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future getAreaWiseStats() async {
    try {
      final res = await _api.getApi(
        getRegionWiseStatsApiUrl(selectedProvince),
        isAuth: true,
        token: storedUser.token,
      );
      selectedProvinceName = res["province"];
      try {
        areaWiseData = {...res["stats"]};
        print(areaWiseData);
      } catch (e) {
        print(e);
        areaWiseData = null;
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
