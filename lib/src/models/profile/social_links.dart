class SocialLinks {
  SocialLinks.fromJson(dynamic json) {
    type = json['type'];
    prefixUrl = json['prefix_url'];
    handle = json['handle'];
    thumbnail = json['thumbnail'];
  }
  String? type;
  String? prefixUrl;
  String? handle;
  String? thumbnail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['prefix_url'] = prefixUrl;
    map['handle'] = handle;
    map['thumbnail'] = thumbnail;
    return map;
  }
}
