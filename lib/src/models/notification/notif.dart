import '../comment/comment.dart';
import '../nft/nft.dart';

class Notif {
  Notif.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    refType = json['ref_type'];
    refObject = json['ref_object'] != null
        ? Comment.fromJson(json['ref_object'])
        : null;
    token = json['token'] != null ? Nft.fromJson(json['token']) : null;
    createdOn = json['created_on'] == null
        ? null
        : DateTime.parse('${json['created_on']}+0000').toLocal();
    read = json['read'];
  }

  String? id;
  String? title;
  String? body;
  String? refType;
  Comment? refObject;
  Nft? token;
  DateTime? createdOn;
  bool? read;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['body'] = body;
    map['ref_type'] = refType;
    if (refObject != null) {
      map['ref_object'] = refObject?.toJson();
    }
    if (token != null) {
      map['token'] = token?.toJson();
    }
    map['created_on'] = createdOn?.toIso8601String();
    map['read'] = read;
    return map;
  }
}
