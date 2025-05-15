import 'package:pa2_kelompok07/model/report/report_request_model.dart';

class ReportResponseModel {
  final int code;
  final String status;
  final String message;
  final ReportRequestModel data;

  ReportResponseModel({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });
  factory ReportResponseModel.fromJson(Map<String, dynamic> json) {
    return ReportResponseModel(
      code: json['code'],
      status: json['status'],
      message: json['message'],
      data: ReportRequestModel.fromJson(json['Data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'status': status,
      'message': message,
      'Data': data.toJson(),
    };
  }
}
