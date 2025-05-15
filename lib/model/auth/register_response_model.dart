import 'login_request_model.dart';

class RegisterResponseModel {
  final int success;
  final String message;
  final User data;

  RegisterResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      success: json['success'],
      message: json['message'],
      data: User.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success' : success,
      'message': message,
      'data': data.toJson(),
    };
  }
}
