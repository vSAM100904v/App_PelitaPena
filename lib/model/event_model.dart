class EventResponse {
  int code;
  String status;
  String message;
  List<Event> data;

  EventResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });

  factory EventResponse.fromJson(Map<String, dynamic> json) {
    return EventResponse(
      code: json['code'],
      status: json['status'],
      message: json['message'],
      data: List<Event>.from(json["Data"].map((x) => Event.fromJson(x))),
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

class Event {
  int id;
  String namaEvent;
  String deskripsiEvent;
  String thumbnailEvent;
  String tanggalPelaksanaan;
  String createdAt;
  String updatedAt;

  Event({
    required this.id,
    required this.namaEvent,
    required this.deskripsiEvent,
    required this.thumbnailEvent,
    required this.tanggalPelaksanaan,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      namaEvent: json['nama_event'] ?? '',
      deskripsiEvent: json['deskripsi_event'] ?? '',
      thumbnailEvent: json['thumbnail_event'] ?? '',
      tanggalPelaksanaan: json['tanggal_pelaksanaan'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_event': namaEvent,
      'deskripsi_event': deskripsiEvent,
      'thumbnail_event': thumbnailEvent,
      'tanggal_pelaksanaan': tanggalPelaksanaan,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
