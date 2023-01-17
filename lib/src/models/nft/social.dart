class Social {
  Social.fromJson(dynamic json) {
    likesCount = json['likes_count'];
    commentsCount = json['comments_count'];
    supportsCount = json['supports_count'];
    supportsReceived = json['supports_received'];
  }

  int? likesCount;
  int? commentsCount;
  int? supportsCount;
  int? supportsReceived;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['likes_count'] = likesCount;
    map['comments_count'] = commentsCount;
    map['supports_count'] = supportsCount;
    map['supports_received'] = supportsReceived;
    return map;
  }
}
