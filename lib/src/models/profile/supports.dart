class Supports {
  Supports({
    this.given,
    this.received,
  });

  Supports.fromJson(dynamic json) {
    given = json['given'];
    received = json['received'];
  }
  int? given;
  int? received;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['given'] = given;
    map['received'] = received;
    return map;
  }
}
