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

  // ID untuk Sumatera Utara (berdasarkan API wilayah Indonesia)
  static const String SUMATERA_UTARA_ID = "12";
  // ID untuk Kabupaten Toba Samosir
  static const String TOBA_SAMOSIR_ID = "1275";

  Future<void> fetchProvinces() async {
    try {
      final response = await http.get(
        Uri.parse('${Config.AREA_API}${Config.PROVINCES}.json'),
      );
      if (response.statusCode == 200) {
        List<dynamic> provincesJson = json.decode(response.body);
        List<Provincies> allProvinces =
            provincesJson.map((json) => Provincies.fromJson(json)).toList();

        // Filter hanya Sumatera Utara
        _provinces =
            allProvinces
                .where(
                  (province) =>
                      province.id == SUMATERA_UTARA_ID ||
                      (province.name != null &&
                          province.name!.toLowerCase().contains(
                            'sumatera utara',
                          )),
                )
                .toList();

        notifyListeners();
      } else {
        throw Exception('Failed to load provinces');
      }
    } catch (e) {
      throw Exception('Error fetching provinces: $e');
    }
  }

  Future<void> fetchCities(String provinceId) async {
    try {
      final response = await http.get(
        Uri.parse('${Config.AREA_API}${Config.CITIES}/$provinceId.json'),
      );
      if (response.statusCode == 200) {
        List<dynamic> citiesJson = json.decode(response.body);
        List<Cities> allCities =
            citiesJson.map((json) => Cities.fromJson(json)).toList();

        // Filter hanya Kabupaten Toba Samosir
        _cities =
            allCities
                .where(
                  (city) =>
                      city.id == TOBA_SAMOSIR_ID ||
                      (city.name != null &&
                          (city.name!.toLowerCase().contains('toba samosir') ||
                              city.name!.toLowerCase().contains('toba'))),
                )
                .toList();

        notifyListeners();
      } else {
        throw Exception('Failed to load cities');
      }
    } catch (e) {
      throw Exception('Error fetching cities: $e');
    }
  }

  void clearCities() {
    _cities.clear();
    notifyListeners();
  }

  Future<void> fetchDistricts(String cityId) async {
    try {
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
    } catch (e) {
      throw Exception('Error fetching districts: $e');
    }
  }

  Future<void> fetchSubDistricts(String districtId) async {
    try {
      final response = await http.get(
        Uri.parse('${Config.AREA_API}${Config.SUB_DISTRICTS}/$districtId.json'),
      );
      if (response.statusCode == 200) {
        List<dynamic> subDistrictsJson = json.decode(response.body);
        _subDistricts =
            subDistrictsJson
                .map((json) => SubDistricts.fromJson(json))
                .toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load sub-districts');
      }
    } catch (e) {
      throw Exception('Error fetching sub-districts: $e');
    }
  }

  // Method tambahan untuk membersihkan data districts dan sub-districts
  void clearDistricts() {
    _districts.clear();
    notifyListeners();
  }

  void clearSubDistricts() {
    _subDistricts.clear();
    notifyListeners();
  }

  // Method untuk reset semua data lokasi
  void clearAllLocationData() {
    _provinces.clear();
    _cities.clear();
    _districts.clear();
    _subDistricts.clear();
    notifyListeners();
  }

  // Method untuk mendapatkan nama provinsi Sumatera Utara
  String getSumateraUtaraName() {
    if (_provinces.isNotEmpty && _provinces.first.name != null) {
      return _provinces.first.name!;
    }
    return "Sumatera Utara";
  }

  // Method untuk mendapatkan nama kabupaten Toba Samosir
  String getTobaSmosirName() {
    if (_cities.isNotEmpty && _cities.first.name != null) {
      return _cities.first.name!;
    }
    return "Kabupaten Toba Samosir";
  }

  // Method untuk validasi apakah user berada di wilayah yang benar
  bool isValidLocation(String provinceId, String cityId) {
    return provinceId == SUMATERA_UTARA_ID && cityId == TOBA_SAMOSIR_ID;
  }
}
