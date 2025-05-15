import 'package:pa2_kelompok07/model/appointment_request_model.dart';

class AppointmentResponseModel {
  final int code;
  final String status;
  final String message;
  final AppointmentRequestModel data;

  AppointmentResponseModel({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });

  factory AppointmentResponseModel.fromJson(Map<String, dynamic> json) {
    return AppointmentResponseModel(
      code: json['code'],
      status: json['status'],
      message: json['message'],
      data: AppointmentRequestModel.fromJson(json['Data']),
    );
  }
}
