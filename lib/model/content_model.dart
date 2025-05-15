import 'package:pa2_kelompok07/model/report/report_category_model.dart';

class ContentResponse {
  int code;
  String status;
  String message;
  List<Content> data;

  ContentResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });

  factory ContentResponse.fromJson(Map<String, dynamic> json) {
    return ContentResponse(
      code: json['code'],
      status: json['status'],
      message: json['message'],
      data: List<Content>.from(json["Data"].map((x) => Content.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'status': status,
      'message': message,
      'Data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}

class Content {
  int id;
  String judul;
  String isiContent;
  String imageContent;
  ViolenceCategory violenceCategory;
  int violenceCategoryId;
  String createdAt;
  String updatedAt;

  Content({
    required this.id,
    required this.judul,
    required this.isiContent,
    required this.imageContent,
    required this.violenceCategory,
    required this.violenceCategoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['id'],
      judul: json['judul'],
      isiContent: json['isi_content'],
      imageContent: json['image_content'],
      violenceCategory: ViolenceCategory.fromJson(json['violence_category']),
      violenceCategoryId: json['violence_category_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'isi_content': isiContent,
      'image_content': imageContent,
      'violence_category': violenceCategory.toJson(),
      'violence_category_id': violenceCategoryId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
