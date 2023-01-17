class Network {
  Network({
    this.id,
    this.name,
  });

  Network.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    thumbnail = json['thumbnail'];
  }
  String? id;
  String? name;
  String? thumbnail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
