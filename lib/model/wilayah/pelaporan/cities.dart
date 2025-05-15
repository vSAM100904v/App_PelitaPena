class Cities {
  Cities({
      this.id, 
      this.provinceId, 
      this.name,});

  Cities.fromJson(dynamic json) {
    id = json['id'];
    provinceId = json['province_id'];
    name = json['name'];
  }
  String? id;
  String? provinceId;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['province_id'] = provinceId;
    map['name'] = name;
    return map;
  }

}