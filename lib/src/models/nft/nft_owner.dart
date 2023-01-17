class NftOwner {
  NftOwner({
    this.displayname,
    this.avatar,
  });

  NftOwner.fromJson(dynamic json) {
    displayname = json['displayname'];
    avatar = json['avatar'];
    id = json['id'];
    isVerified = json['is_verified'];
  }
  String? displayname;
  String? avatar;
  String? id;
  late bool isVerified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['displayname'] = displayname;
    map['avatar'] = avatar;
    return map;
  }
}
