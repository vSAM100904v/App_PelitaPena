class SubDistricts {
  SubDistricts({
      this.id, 
      this.districtId, 
      this.name,});

  SubDistricts.fromJson(dynamic json) {
    id = json['id'];
    districtId = json['district_id'];
    name = json['name'];
  }
  String? id;
  String? districtId;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['district_id'] = districtId;
    map['name'] = name;
    return map;
  }

}