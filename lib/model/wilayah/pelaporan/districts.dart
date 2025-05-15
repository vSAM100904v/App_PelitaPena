class Districts {
  Districts({
      this.id, 
      this.regencyId, 
      this.name,});

  Districts.fromJson(dynamic json) {
    id = json['id'];
    regencyId = json['regency_id'];
    name = json['name'];
  }
  String? id;
  String? regencyId;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['regency_id'] = regencyId;
    map['name'] = name;
    return map;
  }

}