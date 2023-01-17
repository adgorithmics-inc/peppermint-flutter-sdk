import '../nft/nft_owner.dart';

class Comment {
  Comment({
    this.id,
    this.text,
    this.user,
    this.createdOn,
  });

  Comment.fromJson(dynamic json) {
    id = json['id'];
    text = json['text'];
    user = json['user'] != null ? NftOwner.fromJson(json['user']) : null;
    createdOn = json['created_on'] == null
        ? null
        : DateTime.parse('${json['created_on']}+0000').toLocal();
  }

  String? id;
  String? text;
  NftOwner? user;
  DateTime? createdOn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['text'] = text;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    map['created_on'] = createdOn;
    return map;
  }
}
