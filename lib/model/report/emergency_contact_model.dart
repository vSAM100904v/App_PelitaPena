class EmergencyContact {
  final String phone;

  EmergencyContact({required this.phone});

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(phone: json['Phone'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'phone': phone};
  }
}
