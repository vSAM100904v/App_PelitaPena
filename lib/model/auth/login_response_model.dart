import 'login_request_model.dart';

class LoginResponseModel {
  final int success;
  final String message;
  final User data;
  final String token;

  LoginResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.token,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['success'] == null || json['message'] == null || json['data'] == null || json['token'] == null) {
      throw Exception("Data missing in the JSON response");
    }
    return LoginResponseModel(
      success: json['success'] as int,
      message: json['message'] as String,
      data: User.fromJson(json['data'] as Map<String, dynamic>),
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
      'token': token,
    };
  }
}
