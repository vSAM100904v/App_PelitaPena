import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:pa2_kelompok07/model/wilayah/pelaporan/districts.dart';
import 'package:pa2_kelompok07/model/wilayah/pelaporan/provincies.dart';

import '../config.dart';
import '../model/wilayah/pelaporan/cities.dart';
import '../model/wilayah/pelaporan/sub_districts.dart';
import 'package:http/http.dart' as http;

class LocationProvider with ChangeNotifier {
  List<Provincies> _provinces = [];
  List<Cities> _cities = [];
  List<Districts> _districts = [];
  List<SubDistricts> _subDistricts = [];

  List<Provincies> get provinces => _provinces;
  List<Cities> get cities => _cities;
  List<Districts> get districts => _districts;
  List<SubDistricts> get subDistricts => _subDistricts;

  Future<void> fetchProvinces() async {
    final response = await http.get(
      Uri.parse('${Config.AREA_API}${Config.PROVINCES}.json'),
    );
    if (response.statusCode == 200) {
      List<dynamic> provincesJson = json.decode(response.body);
      _provinces =
          provincesJson.map((json) => Provincies.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load provinces');
    }
  }

  Future<void> fetchCities(String provinceId) async {
    final response = await http.get(
      Uri.parse('${Config.AREA_API}${Config.CITIES}/$provinceId.json'),
    );
    if (response.statusCode == 200) {
      List<dynamic> citiesJson = json.decode(response.body);
      _cities = citiesJson.map((json) => Cities.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load cities');
    }
  }

  void clearCities() {
    _cities.clear();
    notifyListeners();
  }

  Future<void> fetchDistricts(String cityId) async {
    final response = await http.get(
      Uri.parse('${Config.AREA_API}${Config.DISTRICTS}/$cityId.json'),
    );
    if (response.statusCode == 200) {
      List<dynamic> districtsJson = json.decode(response.body);
      _districts =
          districtsJson.map((json) => Districts.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load districts');
    }
  }

  Future<void> fetchSubDistricts(String districtId) async {
    final response = await http.get(
      Uri.parse('${Config.AREA_API}${Config.SUB_DISTRICTS}/$districtId.json'),
    );
    if (response.statusCode == 200) {
      List<dynamic> subDistrictsJson = json.decode(response.body);
      _subDistricts =
          subDistrictsJson.map((json) => SubDistricts.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load sub-districts');
    }
  }
}
