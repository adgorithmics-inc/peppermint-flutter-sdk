class Contract {
  Contract({
    this.id,
    this.address,
    this.name,
    this.type,
  });

  Contract.fromJson(dynamic json) {
    id = json['id'];
    address = json['address'];
    name = json['name'];
    type = json['type'];
  }
  String? id;
  String? address;
  String? name;
  String? type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['address'] = address;
    map['name'] = name;
    map['type'] = type;
    return map;
  }
}
