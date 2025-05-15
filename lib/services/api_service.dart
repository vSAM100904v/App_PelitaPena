import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pa2_kelompok07/config.dart';
import 'package:pa2_kelompok07/core/helpers/logger/logger.dart';
import 'package:pa2_kelompok07/core/helpers/toasters/toast.dart';
import 'package:pa2_kelompok07/core/models/notification_response_model.dart';
import 'package:pa2_kelompok07/main.dart';
import 'package:pa2_kelompok07/model/appointment_request_model.dart';
import 'package:pa2_kelompok07/model/appointment_response_model.dart';
import 'package:pa2_kelompok07/model/auth/login_response_model.dart';
import 'package:pa2_kelompok07/model/auth/register_response_model.dart';
import 'package:pa2_kelompok07/model/report/count_report_status.dart';
import 'package:pa2_kelompok07/model/report/emergency_contact_model.dart';
import 'package:pa2_kelompok07/model/report/list_report_model.dart';
import 'package:pa2_kelompok07/model/report/report_request_model.dart';
import 'package:pa2_kelompok07/model/report/report_response_model.dart';
import 'package:pa2_kelompok07/provider/user_provider.dart';
import 'package:pa2_kelompok07/services/shared_service.dart';
import 'package:provider/provider.dart';
import 'package:pa2_kelompok07/model/event_model.dart';

import '../model/auth/login_request_model.dart';
import '../model/content_model.dart';
import '../model/report/full_report_model.dart';
import '../model/report/korban_model.dart';
import '../model/report/report_category_model.dart';
import 'package:path/path.dart';

class APIService {
  static var client = http.Client();
  static final Logger _logger = Logger("API Service");

  static const APIService instance = APIService();
  const APIService();
  Map<String, String> _getHeaders(String accessToken) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
  }

  Future<void> sendPushNotification({
    required String accessToken,
    required int clientId,
    required String title,
    required String body,
    required String type,
    required Map<String, dynamic> data,
  }) async {
    final uri = Uri.parse(Config.apiUrl + Config.pushNotificationRouter);

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'client_id': clientId,
        'title': title,
        'body': body,
        'type': type,
        'data': data,
      }),
    );

    if (response.statusCode == 200) {
      _logger.log('Notification sent successfully: ${response.body}');
    } else {
      _logger.log('Failed to send notification: ${response.statusCode}');
      _logger.log('Response body: ${response.body}');
    }
  }

  Future<ResponseModel> fetchAllReports() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'userToken');
    // Pastikan Config.GetLatestReports sudah didefinisikan di file konfigurasi Anda
    final url = Uri.parse('${Config.apiUrl}${Config.GetLatestReports}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return ResponseModel.fromJson(responseData);
      } else {
        return ResponseModel(
          code: response.statusCode,
          status: 'Error',
          message: 'Server Error: ${response.reasonPhrase}',
          data: [],
        );
      }
    } catch (e) {
      // Handling errors in request atau JSON parsing
      return ResponseModel(
        code: 500,
        status: 'Exception',
        message: 'Exception occurred: $e',
        data: [],
      );
    }
  }

  Future<LoginResponseModel> login(String identifier, String password) async {
    final url = Uri.parse('${Config.apiUrl}${Config.loginAPI}');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': identifier,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('Body: ${response.body}');
      return LoginResponseModel.fromJson(jsonResponse);
      if (jsonResponse['access'] != null &&
          jsonResponse['access'] == 'masyarakat') {
      } else {
        throw Exception(
          'Access Denied: Only users with masyarakat access can login.',
        );
      }
    } else {
      throw Exception(
        'Failed to login. Status code: ${response.statusCode}, Body: ${response.body}',
      );
    }
  }

  Future<RegisterResponseModel> register(
    String email,
    String password,
    String fullName,
    String phoneNumber,
    String notificationToken,
  ) async {
    final url = Uri.parse('${Config.apiUrl}${Config.registerAPI}');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'full_name': fullName,
          'email': email,
          'phone_number': phoneNumber,
          'password': password,
          'notification_token': notificationToken,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['data'] != null) {
          final User newUser = User.fromJson(jsonResponse['data']);
          print('User created: ${newUser.toString()}');
        } else {
          print('No data found in response');
        }
        return RegisterResponseModel.fromJson(jsonResponse);
      } else if (response.statusCode == 400) {
        final jsonResponse = json.decode(response.body);
        throw Exception('Registration failed: ${jsonResponse['message']}');
      } else {
        throw Exception(
          'Failed to register. Status code: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e) {
      print('Error during registration: $e');
      rethrow;
    }
  }

  // Future<LoginResponseModel> forgotPassword(
  //   String email,
  //   String password,
  // ) async {
  //   _logger.log("PROCCESING LOGIN");
  //   final url = Uri.parse('${Config.apiUrl}${Config.forgotPassdword}');

  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(<String, String>{
  //         'email': email,
  //         'password': password,
  //       }),
  //     );
  //     if (response.statusCode == 200) {
  //       final jsonResponse = json.decode(response.body);
  //       if (jsonResponse['data'] != null) {
  //         final User newUser = User.fromJson(jsonResponse['data']);
  //       } else {
  //         _logger.log('No data found in response');
  //       }
  //       return LoginResponseModel.fromJson(jsonResponse);
  //     } else if (response.statusCode == 400) {
  //       final jsonResponse = json.decode(response.body);
  //       throw Exception(
  //         'Gagal mengubah kata sandi: ${jsonResponse['message']}',
  //       );
  //     } else {
  //       throw Exception(
  //         'Gagal mengubah kata sandi. Status code: ${response.statusCode}, Body: ${response.body}',
  //       );
  //     }
  //   } catch (e) {
  //     print('Gagal saat mengubah kata sandi: $e');
  //     rethrow;
  //   }
  // }

  Future<List<ViolenceCategory>> fetchCategories() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'userToken');
    final url = Uri.parse('${Config.apiUrl}${Config.getViolenceCategory}');

    try {
      final response = await client.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['Data'] != null && responseBody['Data'].isNotEmpty) {
          return List<ViolenceCategory>.from(
            responseBody['Data'].map((data) => ViolenceCategory.fromJson(data)),
          );
        } else {
          print('No data available');
          return [];
        }
      } else {
        throw Exception(
          'Failed to fetch categories. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching categories: $e');
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<ReportResponseModel> submitReport(
    int violenceCategory,
    DateTime incidentDate,
    String locationCategory,
    String incidentDescription,
    String detailedAddress,
    String tkpAddress,
    String? documentationFiles,
  ) async {
    final token = await storage.read(key: 'userToken');
    final url = Uri.parse('${Config.apiUrl}${Config.postReport}');

    var request =
        http.MultipartRequest('POST', url)
          ..fields['kategori_kekerasan_id'] = violenceCategory.toString()
          ..fields['tanggal_kejadian'] = incidentDate.toIso8601String()
          ..fields['kategori_lokasi_kasus'] = locationCategory
          ..fields['kronologis_kasus'] = incidentDescription
          ..fields['alamat_detail_tkp'] = detailedAddress
          ..fields['alamat_tkp'] = tkpAddress
          ..headers['Authorization'] = 'Bearer $token';

    if (documentationFiles != null) {
      request.fields['dokumentasi'] = documentationFiles;
    }

    try {
      var streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return ReportResponseModel.fromJson(json.decode(response.body));
      } else {
        print(
          'Failed to submit report. Status code: ${response.statusCode}, Body: ${response.body}',
        );
        throw Exception(
          'Failed to submit report. Status code: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e) {
      print('Error during submitting report: $e');
      rethrow;
    }
  }

  Future<KorbanResponseModel> submitReportKorban(
    String noRegistrasi,
    String nikKorban,
    String namaKorban,
    String usiaKorban,
    String alamatKorban,
    String alamatDetail,
    String jenisKelamin,
    String agama,
    String noTelepon,
    String pendidikan,
    String pekerjaan,
    String statusPerkawinan,
    String kebangsaan,
    String hubunganDenganPelaku,
    String keteranganLainnya,
    List<io.File> dokumentasiKorban,
  ) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'userToken');
    final url = Uri.parse('${Config.apiUrl}${Config.postReportKorban}');

    var request = http.MultipartRequest('POST', url);

    request.fields['no_registrasi'] = noRegistrasi;
    request.fields['nik_korban'] = nikKorban;
    request.fields['nama_korban'] = namaKorban;
    request.fields['usia_korban'] = usiaKorban;
    request.fields['alamat_korban'] = alamatKorban;
    request.fields['alamat_detail'] = alamatDetail;
    request.fields['jenis_kelamin'] = jenisKelamin;
    request.fields['agama'] = agama;
    request.fields['no_telepon'] = noTelepon;
    request.fields['pendidikan'] = pendidikan;
    request.fields['pekerjaan'] = pekerjaan;
    request.fields['status_perkawinan'] = statusPerkawinan;
    request.fields['kebangsaan'] = kebangsaan;
    request.fields['hubungan_dengan_pelaku'] = hubunganDenganPelaku;
    request.fields['keterangan_lainnya'] = keteranganLainnya;

    for (var file in dokumentasiKorban) {
      if (await file.exists()) {
        request.files.add(
          await http.MultipartFile.fromPath('dokumentasi_korban', file.path),
        );
      } else {
        print("File does not exist: ${file.path}");
      }
    }

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    });

    try {
      var streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return KorbanResponseModel.fromJson(jsonResponse);
      } else {
        print('Response body: ${response.body}');
        throw Exception(
          'Failed to submit korban report. Status code: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error while submitting korban report: $e');
    }
  }

  Future<void> cancelReport(
    String noRegistrasi,
    String alasanDibatalkan,
  ) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'userToken');
    final url = Uri.parse(
      '${Config.apiUrl}${Config.cancelReport}/$noRegistrasi',
    );

    var request = http.MultipartRequest('PUT', url);

    request.fields['alasan_dibatalkan'] = alasanDibatalkan;

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    });

    try {
      var response = await request.send();

      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print('Laporan berhasil dibatalkan: $respStr');
      } else {
        throw Exception(
          'Gagal membatalkan laporan. Status code: ${response.statusCode}, Body: $respStr',
        );
      }
    } catch (e) {
      throw Exception('Error saat membatalkan laporan: $e');
    }
  }

  Future<ResponseModel> fetchUserReports() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'userToken');
    final url = Uri.parse('${Config.apiUrl}${Config.getReportByUser}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _logger.log('Response Data: ${responseData["Data"].length}');
        return ResponseModel.fromJson(responseData);
      } else {
        return ResponseModel(
          code: response.statusCode,
          status: 'Error',
          message: 'Server Error: ${response.reasonPhrase}',
          data: [],
        );
      }
    } catch (e) {
      // Handling errors in request or JSON parsing
      return ResponseModel(
        code: 500,
        status: 'Exception',
        message: 'Exception occurred: $e',
        data: [],
      );
    }
  }

  Future<DetailResponseModel> getFullReportDetails(
    String noRegistrasi,
    bool isAdmin,
  ) async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'userToken');
      final url = Uri.parse(
        isAdmin
            ? '${Config.apiUrl}${Config.getDetailReportByAdmin}/$noRegistrasi'
            : '${Config.apiUrl}${Config.getDetailReportByUser}/$noRegistrasi',
      );

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        _logger.log(
          'jsonDecode(response.body.toString()): ${jsonDecode(response.body.toString())}',
        );
        _logger.log("SUDAHH SUCKSESSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
        return DetailResponseModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load report details ${response.body}');
      }
    } catch (e) {
      _logger.log('Error: $e');
      throw Exception('Failed to load report details ${e.toString()}');
    }
  }

  Future<List<ReportRequestModel>> fetchReportsEnter() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'userToken');
    final url = Uri.parse('${Config.apiUrl}${Config.getReportByUser}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['Data'] != null && responseBody['Data'].isNotEmpty) {
          var filteredData =
              responseBody['Data']
                  .where(
                    (data) =>
                        data['status'] != null &&
                        data['status'].toString() == 'Laporan masuk',
                  )
                  .toList();

          return List<ReportRequestModel>.from(
            filteredData.map((data) => ReportRequestModel.fromJson(data)),
          );
        } else {
          print('No data available');
          return [];
        }
      } else {
        throw Exception(
          'Failed to fetch reports. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching reports: $e');
      throw Exception('Error fetching reports: $e');
    }
  }

  Future<List<ReportRequestModel>> fetchReportsProcess() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'userToken');
    final url = Uri.parse('${Config.apiUrl}${Config.getReportByUser}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['Data'] != null && responseBody['Data'].isNotEmpty) {
          var filteredData =
              responseBody['Data']
                  .where(
                    (data) =>
                        data['status'] != null &&
                        data['status'].toString() == 'Diproses',
                  )
                  .toList();

          return List<ReportRequestModel>.from(
            filteredData.map((data) => ReportRequestModel.fromJson(data)),
          );
        } else {
          print('No data available');
          return [];
        }
      } else {
        throw Exception(
          'Failed to fetch reports. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching reports: $e');
      throw Exception('Error fetching reports: $e');
    }
  }

  Future<ReportRequestModel> fetchReportByRegistration(
    String noRegistrasi,
  ) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    final token = await storage.read(key: 'userToken');
    final url = Uri.parse(
      '${Config.apiUrl}${Config.getDetailReportByUser}/$noRegistrasi',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ReportRequestModel.fromJson(data);
    } else {
      throw Exception(
        'Failed to fetch report. Status code: ${response.statusCode}',
      );
    }
  }

  Future<AppointmentResponseModel> submitAppointment(
    DateTime waktuDimulai,
    DateTime waktuSelesai,
    String keperluanKonsultasi,
  ) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'userToken');
    var uri = Uri.parse('${Config.apiUrl}${Config.createJanjiTemu}');

    var request =
        http.MultipartRequest('POST', uri)
          ..fields['waktu_dimulai'] = waktuDimulai.toIso8601String()
          ..fields['waktu_selesai'] = waktuSelesai.toIso8601String()
          ..fields['keperluan_konsultasi'] = keperluanKonsultasi
          ..headers['Authorization'] = 'Bearer $token';

    try {
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      if (response.statusCode == 201) {
        print('Janji temu berhasil dibuat. Body: $responseString');
        return AppointmentResponseModel.fromJson(jsonDecode(responseString));
      } else {
        print(
          'Gagal membuat janji temu. Status code: ${response.statusCode}, Body: $responseString',
        );
        throw Exception(
          'Gagal membuat janji temu. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error saat membuat janji temu: $e');
    }
  }

  Future<List<AppointmentRequestModel>> fetchAppointments() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'userToken');
    final url = Uri.parse('${Config.apiUrl}${Config.getJanjiTemu}');

    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['Data'] != null && responseBody['Data'].isNotEmpty) {
        List<dynamic> reportData = responseBody['Data'];
        return reportData
            .map((data) => AppointmentRequestModel.fromJson(data))
            .toList();
      } else {
        print('No data available');
        return [];
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      forceLogoutAndRedirect();
      throw Exception('Unauthorized access: ${response.statusCode}');
    } else {
      throw Exception(
        'Failed to fetch reports. Status code: ${response.statusCode}',
      );
    }
  }

  Future<void> editAppointment(
    int appointmentId,
    DateTime waktuDimulai,
    DateTime waktuSelesai,
    String keperluanKonsultasi,
  ) async {
    // Validasi input
    if (waktuDimulai.isBefore(DateTime.now())) {
      throw Exception('Waktu dimulai tidak boleh di masa lalu');
    }
    if (waktuSelesai.isBefore(waktuDimulai)) {
      throw Exception('Waktu selesai harus setelah waktu dimulai');
    }
    if (keperluanKonsultasi.isEmpty) {
      throw Exception('Keperluan konsultasi tidak boleh kosong');
    }

    FlutterSecureStorage storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'userToken');
    var uri = Uri.parse(
      '${Config.apiUrl}${Config.editJanjiTemu}/$appointmentId',
    );

    try {
      var response = await http.put(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'waktu_dimulai': waktuDimulai.toIso8601String(),
          'waktu_selesai': waktuSelesai.toIso8601String(),
          'keperluan_konsultasi': keperluanKonsultasi,
        }),
      );

      var responseString = response.body;

      if (response.statusCode == 200) {
        print('Janji temu berhasil diedit. Body: $responseString');
      } else {
        print(
          'Gagal mengedit janji temu. Status code: ${response.statusCode}, Body: $responseString',
        );
        throw Exception(
          'Gagal mengedit janji temu. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error saat mengedit janji temu: $e');
      throw Exception('Error saat mengedit janji temu: $e');
    }
  }

  Future<void> cancelAppointment(int appointmentId, String reason) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'userToken');
    final url = Uri.parse(
      '${Config.apiUrl}${Config.batalJanjiTemu}/$appointmentId',
    );

    var request = http.MultipartRequest('PUT', url);

    request.fields['alasan_dibatalkan'] = reason;

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    });

    try {
      var response = await request.send();

      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print('Janji temu berhasil dibatalkan: $respStr');
      } else {
        throw Exception(
          'Gagal membatalkan janji temu. Status code: ${response.statusCode}, Body: $respStr',
        );
      }
    } catch (e) {
      throw Exception('Error saat membatalkan janji temu: $e');
    }
  }

  Future<void> editProfil(String fullName, String email, String noTelp) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'userToken');
    final url = Uri.parse('${Config.apiUrl}${Config.editProfil}');

    var request = http.MultipartRequest('PUT', url);

    request.fields['alasan_dibatalkan'] = fullName;
  }

  Future<List<Content>> fetchContents() async {
    http.Response response = await http.get(
      Uri.parse('${Config.apiUrl}${Config.getContent}'),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['code'] == 200) {
        List<dynamic> contentsJson = data['Data'];
        List<Content> contents =
            contentsJson.map((json) => Content.fromJson(json)).toList();
        return contents;
      } else {
        throw Exception('Failed to load content data');
      }
    } else {
      throw Exception('Failed to reach the server');
    }
  }

  Future<void> sendTokenToServer(String notificationToken) async {
    String? authorizationToken = await storage.read(key: 'userToken');
    try {
      _logger.log(
        'Attempting to send FCM token to server with Params FCM TOKEN:$notificationToken, Bearer Token:$authorizationToken',
      );
      final url = Uri.parse(
        '${Config.apiUrl}${Config.updateNotificationToken}?notification_token=$notificationToken',
      );

      _logger.log('Sending FCM token to server: $url');
      final response = await client.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $authorizationToken',
        },
      );
      _logger.log("INI ADALAH RESPONSE ${response.body}");
      if (response.statusCode == 200) {
        _logger.log('FCM token successfully sent to server');
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        forceLogoutAndRedirect();
        throw Exception('Failed to send FCM token: ${response.statusCode}');
      }
    } catch (e) {
      _logger.log('Error sending FCM token to server: $e');
    }
  }

  Future<Map<String, dynamic>> fetchNotifications(
    String token,
    int pageKey,
    int limit,
  ) async {
    _logger.log(
      'Fetching notifications for page $pageKey with limit $limit amd token $token',
    );
    final url = Uri.parse(
      '${Config.apiUrl}${Config.retrieveUserNotification}?page=$pageKey&limit=$limit',
    );
    final response = await client.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      _logger.log('Response Succes for fetch Notifications');
      final jsonData = jsonDecode(response.body);
      _logger.log('jsonData: $jsonData', level: LogLevel.success);
      final data = jsonData['Data'] as Map<String, dynamic>;
      final notifications =
          (data['notifications'] as List)
              .map(
                (json) =>
                    NotificationPayload.fromJson(json as Map<String, dynamic>),
              )
              .toList();
      final pagination = data['pagination'] as Map<String, dynamic>;

      final payload = {
        'notifications': notifications,
        'page': pagination['page'] as int,
        'totalPages': pagination['total_pages'] as int,
        'limit': pagination['limit'] as int,
      };
      _logger.log('Payload: $payload', level: LogLevel.success);
      return payload;
    } else {
      _logger.log('Failed to load notifications: ${response.statusCode}');
      throw Exception('Failed to load notifications: ${response.statusCode}');
    }
  }

  Future<int> fetchUnreadNotificationCount(String accessToken) async {
    try {
      final url = "${Config.apiUrl}${Config.retrieveUnreadNotificationCount}";
      final response = await client.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Memeriksa apakah 'Data' ada dan 'unread_count' dapat diakses
        if (data['Data'] != null && data['Data']['unread_count'] != null) {
          // Mengonversi unread_count ke integer
          int unreadCount =
              int.tryParse(data['Data']['unread_count'].toString()) ?? 0;
          return unreadCount;
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        forceLogoutAndRedirect();
        throw Exception('Invalid Authorization Token: ${response.body}');
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      _logger.log('Error fetching unread count: $e');
      throw Exception('Failed to load notifications: ${e.toString()}');
    }

    // Ensure that the function always returns an int
    return 0; // or any default value you want to return
  }

  Future<void> markNotificationAsRead(
    String accessToken,
    int notificationId,
  ) async {
    try {
      final url =
          "${Config.apiUrl}${Config.markNotificationAsRead}?notification_id=$notificationId";
      final response = await client.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        _logger.log(
          "Succes mark $notificationId as read and message from response ${data['message']}",
        );
      } else {
        throw Exception(
          'Failed to load notifications: ${response.body} $notificationId',
        );
      }
    } catch (e) {
      _logger.log('Error fetching unread count: $e');
      throw Exception('Failed to load notifications: ${e.toString()}');
    }
  }

  Future<void> forceLogoutAndRedirect() async {
    final ctx = navigatorKey.currentContext;
    if (ctx != null) {
      ctx.toast.showWarning(
        'Wah session kamu telah Expired nih, silahkan login kembali ya',
      );
      Navigator.of(ctx).pushNamedAndRemoveUntil('/login', (route) => false);
      await Provider.of<UserProvider>(ctx, listen: false).logout();
    }
  }

  // Admin Router

  Future<Map<String, dynamic>> retrieveAvailableReportsAdminService(
    String accessToken,
    int page,
    int limit,
  ) async {
    try {
      // Menambahkan query parameter ke URL
      final url = Uri.parse(
        "${Config.apiUrl}${Config.GetLatestReports}",
      ).replace(
        queryParameters: {'page': page.toString(), 'limit': limit.toString()},
      );

      final response = await client.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Sekarang response akan berisi data dan meta
        _logger.log(
          "This Result From Data ${data['data']}",
        ); // Mengubah 'Data' menjadi 'data'
        _logger.log("Pagination Info: ${data['meta']}");
        final reportsData = data['data'] as List? ?? [];
        final reports =
            reportsData
                .map(
                  (reportJson) => ListLaporanModel.fromJson(
                    reportJson as Map<String, dynamic>,
                  ),
                )
                .toList();
        final payload = {
          'reports': reports,
          'page': data['meta']["page"] as int,
          'totalPages': data['meta']["totalPage"] as int,
          'limit': data['meta']["limit"] as int,
        };

        _logger.log("INI DATA YANG DI PAYLOAD ${payload['reports']}");
        return payload;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        forceLogoutAndRedirect();
        throw Exception('Failed to send FCM token: ${response.statusCode}');
      } else {
        throw Exception('Failed to load notifications: ${response.body} ');
      }
    } catch (e) {
      _logger.log('Error Pagination: $e');
      throw Exception('Failed to Pagination reports Admin: ${e.toString()}');
    }
  }

  Future<void> updateStatusReportAsReadAdminService({
    required String accessToken,
    required String noRegistrasi,
  }) async {
    try {
      final url = Uri.parse(
        '${Config.apiUrl}${Config.updateStatusReportAsReadAdminRouter}/$noRegistrasi',
      );
      final response = await client.put(url, headers: _getHeaders(accessToken));

      // Log seluruh response body
      _logger.log('View Report Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Log hanya data
        _logger.log('View Report Data: ${data['data']}');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid or missing token');
      } else if (response.statusCode == 404) {
        throw Exception('Report not found');
      } else {
        throw Exception('Failed to view report: ${response.body}');
      }
    } catch (e) {
      _logger.log('Error viewing report: $e');
      rethrow;
    }
  }

  // Method untuk AdminProsesLaporan
  Future<void> updateStatusReportAsProcessAdminService({
    required String accessToken,
    required String noRegistrasi,
    required BuildContext innerContext,
  }) async {
    try {
      final url = Uri.parse(
        '${Config.apiUrl}${Config.updateStatusReportAsProcessAdminRouter}/$noRegistrasi',
      );
      final response = await client.put(url, headers: _getHeaders(accessToken));

      // Log seluruh response body
      _logger.log('Process Report Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Log hanya data
        _logger.log('Process Report Data: ${data['data']}');
        innerContext.toast.showSuccess("Status berhasil diubah ");
      } else if (response.statusCode == 404) {
        throw Exception('Report not found');
      } else if (response.statusCode == 500) {
        final data = jsonDecode(response.body);
        throw Exception('Failed to process report: ${data['message']}');
      } else {
        throw Exception('Failed to process report: ${response.body}');
      }
    } catch (e) {
      innerContext.toast.showSuccess("Status Gagal dirubah $e");
      _logger.log('Error processing report: $e');
      rethrow;
    }
  }

  // Method untuk SelesaikanLaporan
  Future<void> updateStatusReportAsDoneAdminService({
    required String accessToken,
    required String noRegistrasi,
    required BuildContext innerContext,
  }) async {
    try {
      final url = Uri.parse(
        '${Config.apiUrl}${Config.updateStatusReportAsDoneAdminRouter}/$noRegistrasi',
      );
      final response = await client.put(url, headers: _getHeaders(accessToken));

      // Log seluruh response body
      _logger.log('Complete Report Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Log hanya data
        _logger.log('Complete Report Data: ${data['data']}');
        innerContext.toast.showSuccess('Data berhasil disimpan!');
      } else if (response.statusCode == 404) {
        throw Exception('Report not found');
      } else if (response.statusCode == 500) {
        final data = jsonDecode(response.body);

        throw Exception('Failed to complete report: ${data['message']}');
      } else {
        throw Exception('Failed to complete report: ${response.body}');
      }
    } catch (e) {
      _logger.log('Error completing report: $e');
      innerContext.toast.showSuccess("Status Gagal dirubah $e");
      rethrow;
    }
  }

  Future<List<String>> _uploadDocumentsToCloudinary(
    List<File> documents,
  ) async {
    try {
      final documentUrls = <String>[];
      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/dgnexszl2/image/upload',
      );

      for (final document in documents) {
        final request =
            http.MultipartRequest('POST', uri)
              ..fields['upload_preset'] = "tracking_laporan"
              ..fields['api_key'] = "228927731812515"
              ..fields['folder'] = 'tracking_documents'
              ..fields['quality'] = 'auto'
              ..files.add(
                await http.MultipartFile.fromPath('file', document.path),
              );

        _logger.log('Uploading document to Cloudinary: ${uri.toString()}');
        final response = await request.send();
        final responseBody = await response.stream.bytesToString();
        final responseData = jsonDecode(responseBody);

        if (response.statusCode != 200) {
          _logger.log(
            'Cloudinary upload failed for document ${document.path}: $responseBody',
          );
          throw Exception(
            'Failed to upload document to Cloudinary: ${responseData['error']?['message'] ?? 'Unknown error'}',
          );
        }

        final documentUrl = responseData['secure_url'] as String;
        _logger.log('Document uploaded to Cloudinary: $documentUrl');
        documentUrls.add(documentUrl);
      }

      return documentUrls;
    } catch (e) {
      _logger.log('Error uploading documents to Cloudinary: $e');
      throw Exception('Failed to upload documents: $e');
    }
  }

  Future<Map<String, dynamic>> createTrackingLaporan({
    required String noRegistrasi,
    required String keterangan,
    List<File>? documents,
  }) async {
    try {
      String? authorizationToken = await storage.read(key: 'userToken');
      final url = Uri.parse(
        "${Config.apiUrl}${Config.createTrackingReportAdminRouter}",
      );

      // Unggah dokumen ke Cloudinary jika ada
      List<String> documentUrls = [];
      if (documents != null && documents.isNotEmpty) {
        documentUrls = await _uploadDocumentsToCloudinary(documents);
      }

      // Buat body JSON
      final body = {
        'no_registrasi': noRegistrasi,
        'document': documentUrls,
        "keterangan": keterangan,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authorizationToken',
        },
        body: jsonEncode(body),
      );

      final responseBody = response.body;
      final decodedResponse = jsonDecode(responseBody);

      _logger.log('CreateTrackingLaporan Response Body: $responseBody');
      if (decodedResponse['Data'] != null) {
        _logger.log('CreateTrackingLaporan Data: ${decodedResponse['Data']}');
      }

      if (response.statusCode == 201) {
        return decodedResponse; // Kembalikan seluruh respons
      } else if (response.statusCode == 400) {
        throw Exception('Bad Request: ${decodedResponse['message']}');
      } else if (response.statusCode == 500) {
        throw Exception('Server Error: ${decodedResponse['message']}');
      } else {
        throw Exception(
          'Unexpected error: ${response.statusCode} - ${decodedResponse['message']}',
        );
      }
    } catch (e) {
      _logger.log('Error in CreateTrackingLaporan: $e');
      rethrow;
    }
  }

  // Method untuk Update Tracking Laporan
  // Future<Map<String, dynamic>> updateTrackingLaporan({
  //   required String id,
  //   String? noRegistrasi, // Opsional
  //   String? keterangan, // Opsional
  //   List<File>? documents, // Opsional untuk upload file
  // }) async {
  //   try {
  //     String? authorizationToken = await storage.read(key: 'userToken');
  //     final url = Uri.parse(
  //       "${Config.apiUrl}${Config.updateTrackingReportAdminRouter}/$id",
  //     );
  //     var request = http.MultipartRequest('PUT', url)
  //       ..headers.addAll({
  //         'Content-Type': 'multipart/form-data',
  //         'Authorization': 'Bearer $authorizationToken',
  //       });

  //     // Tambahkan fields yang opsional jika ada
  //     if (noRegistrasi != null) {
  //       request.fields['no_registrasi'] = noRegistrasi;
  //     }
  //     if (keterangan != null) {
  //       request.fields['keterangan'] = keterangan;
  //     }

  //     // Tambahkan dokumen jika ada
  //     if (documents != null && documents.isNotEmpty) {
  //       for (var file in documents) {
  //         request.files.add(
  //           await http.MultipartFile.fromPath(
  //             'document',
  //             file.path,
  //             contentType: DioMediaType('application', 'octet-stream'),
  //           ),
  //         );
  //       }
  //     }

  //     final response = await request.send();
  //     final responseBody = await response.stream.bytesToString();
  //     final decodedResponse = jsonDecode(responseBody);

  //     // Logging response body dan data
  //     _logger.log('UpdateTrackingLaporan Response Body: $responseBody');
  //     if (decodedResponse['data'] != null) {
  //       _logger.log('UpdateTrackingLaporan Data: ${decodedResponse['data']}');
  //     }

  //     if (response.statusCode == 200) {
  //       return decodedResponse;
  //     } else if (response.statusCode == 400) {
  //       throw Exception('Bad Request: ${decodedResponse['message']}');
  //     } else if (response.statusCode == 404) {
  //       throw Exception('Not Found: ${decodedResponse['message']}');
  //     } else if (response.statusCode == 500) {
  //       throw Exception('Server Error: ${decodedResponse['message']}');
  //     } else {
  //       throw Exception(
  //         'Unexpected error: ${response.statusCode} - ${decodedResponse['message']}',
  //       );
  //     }
  //   } catch (e) {
  //     _logger.log('Error in UpdateTrackingLaporan: $e');
  //     rethrow;
  //   }
  // }

  Future<Map<String, dynamic>> updateTrackingLaporan({
    required String id,
    String? noRegistrasi,
    String? keterangan,
    List<File>? documents,
  }) async {
    try {
      String? authorizationToken = await storage.read(key: 'userToken');
      final url = Uri.parse(
        "${Config.apiUrl}${Config.updateTrackingReportAdminRouter}/$id",
      );

      // Unggah dokumen ke Cloudinary jika ada
      List<String> documentUrls = [];
      if (documents != null && documents.isNotEmpty) {
        documentUrls = await _uploadDocumentsToCloudinary(documents);
      }

      // Buat body JSON
      final body = <String, dynamic>{};
      if (noRegistrasi != null) body['no_registrasi'] = noRegistrasi;
      if (keterangan != null) body['keterangan'] = keterangan;
      if (documentUrls.isNotEmpty) body['document'] = documentUrls;

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authorizationToken',
        },
        body: jsonEncode(body),
      );

      final responseBody = response.body;
      final decodedResponse = jsonDecode(responseBody);

      _logger.log('UpdateTrackingLaporan Response Body: $responseBody');
      if (decodedResponse['data'] != null) {
        _logger.log('UpdateTrackingLaporan Data: ${decodedResponse['data']}');
      }

      if (response.statusCode == 200) {
        return decodedResponse;
      } else if (response.statusCode == 400) {
        throw Exception('Bad Request: ${decodedResponse['message']}');
      } else if (response.statusCode == 404) {
        throw Exception('Not Found: ${decodedResponse['message']}');
      } else if (response.statusCode == 500) {
        throw Exception('Server Error: ${decodedResponse['message']}');
      } else {
        throw Exception(
          'Unexpected error: ${response.statusCode} - ${decodedResponse['message']}',
        );
      }
    } catch (e) {
      _logger.log('Error in UpdateTrackingLaporan: $e');
      rethrow;
    }
  }

  // Method untuk Delete Tracking Laporan
  Future<Map<String, dynamic>> deleteTrackingLaporan({
    required String id,
  }) async {
    try {
      String? authorizationToken = await storage.read(key: 'userToken');
      final url = Uri.parse(
        "${Config.apiUrl}${Config.deleteTrackingReportAdminRouter}/$id",
      );
      final response = await client.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authorizationToken',
        },
      );

      final responseBody = response.body;
      final decodedResponse = jsonDecode(responseBody);

      // Logging response body
      _logger.log('DeleteTrackingLaporan Response Body: $responseBody');
      // Tidak ada 'data' pada response delete, jadi tidak perlu log 'data'

      if (response.statusCode == 200) {
        return decodedResponse;
      } else if (response.statusCode == 400) {
        throw Exception('Bad Request: ${decodedResponse['message']}');
      } else if (response.statusCode == 404) {
        throw Exception('Not Found: ${decodedResponse['message']}');
      } else if (response.statusCode == 500) {
        throw Exception('Server Error: ${decodedResponse['message']}');
      } else {
        throw Exception(
          'Unexpected error: ${response.statusCode} - ${decodedResponse['message']}',
        );
      }
    } catch (e) {
      _logger.log('Error in DeleteTrackingLaporan: $e');
      rethrow;
    }
  }

  Future<CountReportStatus> fetchStatusStats() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'userToken');
    final response = await http.get(
      Uri.parse('${Config.apiUrl}${Config.reportStatusCountRouter}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['status'] == 'success') {
        _logger.log("INI ADLAAH DATANYAAAAAAA $jsonData");
        return CountReportStatus.fromJson(jsonData['Data']);
      } else {
        throw Exception('Failed to load status stats: ${jsonData['message']}');
      }
    } else {
      throw Exception('Failed to load status stats: ${response.statusCode}');
    }
  }

  Future<EmergencyContact> updateEmergencyContact(
    EmergencyContact updatedContact,
  ) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'userToken');
    final response = await http.put(
      Uri.parse('${Config.apiUrl}${Config.editEmergencyContactAPI}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updatedContact.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['success'] == 1) {
        return EmergencyContact.fromJson(jsonData['data']);
      } else {
        throw Exception(
          'Failed to update emergency contact: ${jsonData['message']}',
        );
      }
    } else {
      throw Exception(
        'Failed to update emergency contact: ${response.statusCode}',
      );
    }
  }

  Future<String> fetchEmergencyContact() async {
    final url = Uri.parse("${Config.apiUrl}${Config.emergencyContactAPI}");
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'userToken');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    _logger.log("INI NDATANYA ${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _logger.log("INI NDATANYA ${response.body}");
      return data['data']['Phone'] as String;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      forceLogoutAndRedirect();
      throw Exception('Failed to send FCM token: ${response.statusCode}');
    } else {
      throw Exception('Gagal mengambil data kontak darurat');
    }
  }

  Future<List<Event>> fetchEvents() async {
    final response = await http.get(
      Uri.parse('${Config.apiUrl}${Config.getEventContent}'),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['code'] == 200) {
        List<dynamic> eventsJson = data['Data'];
        List<Event> events =
            eventsJson.map((json) => Event.fromJson(json)).toList();
        return events;
      } else {
        throw Exception('Failed to load event data: ${data['message']}');
      }
    } else {
      throw Exception('Failed to reach the server');
    }
  }

  /// POST {Config.apiUrl}{Config.ResetPassword}
  static Future<void> forgotPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final uri = Uri.parse('${Config.apiUrl}${Config.ResetPassword}');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      }),
    );

    if (response.statusCode != 200) {
      // coba parse JSON error, kalau gagal gunakan plain text
      try {
        final body = jsonDecode(response.body);
        final msg = body['Message'] ?? body['message'] ?? response.body;
        throw Exception(msg);
      } catch (_) {
        throw Exception(response.body);
      }
    }
    // kalau 200, anggap sukses
  }
}
