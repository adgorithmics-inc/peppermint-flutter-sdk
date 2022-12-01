class Party {
  Party({
    this.id,
    this.displayname,
    this.avatar,
    this.isVerified,
  });

  Party.fromJson(dynamic json) {
    id = json['id'];
    displayname = json['displayname'];
    avatar = json['avatar'];
    isVerified = json['is_verified'];
  }
  String? id;
  String? displayname;
  String? avatar;
  bool? isVerified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['displayname'] = displayname;
    map['avatar'] = avatar;
    map['is_verified'] = isVerified;
    return map;
  }
}
