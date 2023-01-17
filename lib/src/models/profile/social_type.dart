class SocialType {
  SocialType({
    this.publicId,
    this.name,
    this.url,
  });

  SocialType.fromJson(dynamic json) {
    publicId = json['public_id'];
    name = json['name'];
    url = json['url'];
  }
  String? publicId;
  String? name;
  String? url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['public_id'] = publicId;
    map['name'] = name;
    map['url'] = url;
    return map;
  }
}
