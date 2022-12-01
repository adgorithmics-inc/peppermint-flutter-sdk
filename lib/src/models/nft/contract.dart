class Contract {
  Contract({
    this.address,
    this.name,
  });

  Contract.fromJson(dynamic json) {
    address = json['address'];
    name = json['name'];
  }

  String? address;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address'] = address;
    map['name'] = name;
    return map;
  }
}
