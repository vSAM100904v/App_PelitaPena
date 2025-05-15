class User {
  final int id;
  final String full_name;
  final String? username;
  final String? role;
  final String? photo_profile;
  final String? phone_number;
  final String email;
  final int? nik;
  final String? tempatLahir;
  final DateTime? tanggalLahir;
  final String? jenisKelamin;
  final String? alamat;
  final String password;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  // !UPDATED: ADDED NEW FIELD FOR NOTIFICATION TOKEN
  final String? notificationToken;
  User({
    required this.id,
    required this.full_name,
    this.username,
    this.role,
    this.photo_profile = "",
    this.phone_number,
    required this.email,
    this.nik,
    this.tempatLahir = "",
    this.tanggalLahir,
    this.jenisKelamin = "",
    this.alamat = "",
    required this.password,
    this.createdAt,
    this.updatedAt,
    // !UPDATED: ADDED NEW FIELD FOR NOTIFICATION TOKEN
    this.notificationToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      full_name: json['full_name'] ?? "",
      username: json['username'] ?? "",
      role: json['role'] ?? "",
      photo_profile: json['photo_profile'] ?? "",
      phone_number: json['phone_number'] ?? "",
      email: json['email'] ?? "",
      nik: json['nik'] ?? 0,
      tempatLahir: json['tempat_lahir'] ?? "",
      tanggalLahir:
          json['tanggal_lahir'] != null
              ? DateTime.parse(json['tanggal_lahir'])
              : null,
      jenisKelamin: json['jenis_kelamin'] ?? "",
      alamat: json['alamat'] ?? "",
      password: json['password'],
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
      notificationToken: json['notification_token'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': full_name,
      'username': username,
      'role': role,
      'photo_profile': photo_profile,
      'phone_number': phone_number,
      'email': email,
      'nik': nik,
      'tempat_lahir': tempatLahir,
      'tanggal_lahir': tanggalLahir?.toIso8601String(),
      'jenis_kelamin': jenisKelamin,
      'alamat': alamat,
      'password': password,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'notification_token': notificationToken,
    };
  }

  User copyWith({
    int? id,
    String? full_name,
    String? username,
    String? role,
    String? photo_profile,
    String? phone_number,
    String? email,
    int? nik,
    String? tempatLahir,
    DateTime? tanggalLahir,
    String? jenisKelamin,
    String? alamat,
    String? password,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notificationToken,
  }) {
    return User(
      id: id ?? this.id,
      full_name: full_name ?? this.full_name,
      username: username ?? this.username,
      role: role ?? this.role,
      photo_profile: photo_profile ?? this.photo_profile,
      phone_number: phone_number ?? this.phone_number,
      email: email ?? this.email,
      nik: nik ?? this.nik,
      tempatLahir: tempatLahir ?? this.tempatLahir,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      alamat: alamat ?? this.alamat,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notificationToken: notificationToken ?? this.notificationToken,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, full_name: $full_name, username: $username, role: $role, '
        'photo_profile: $photo_profile, phone_number: $phone_number, email: $email, '
        'nik: $nik, tempatLahir: $tempatLahir, tanggalLahir: $tanggalLahir, '
        'jenisKelamin: $jenisKelamin, alamat: $alamat, createdAt: $createdAt, '
        'updatedAt: $updatedAt)';
  }

  // !UPDATED: ADDED NEW FIELD FOR Validate Notification TOKEN
  bool hasValidNotificationToken() {
    return notificationToken != null &&
        notificationToken!.isNotEmpty &&
        notificationToken != "";
  }
}
