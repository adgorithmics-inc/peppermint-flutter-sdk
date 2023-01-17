import '../nft/nft.dart';
import 'party.dart';

class BalanceHistory {
  BalanceHistory({
    this.id,
    this.amount,
    this.description,
    this.refType,
    this.token,
    this.createdOn,
  });

  BalanceHistory.fromJson(dynamic json) {
    id = json['id'];
    amount = json['amount'];
    description = json['description'];
    party = json['party'] != null ? Party.fromJson(json['party']) : null;
    refType = json['ref_type'];
    token = json['token'] != null ? Nft.fromJson(json['token']) : null;
    createdOn = json['created_on'] == null
        ? null
        : DateTime.parse('${json['created_on']}+0000').toLocal();
  }

  String? id;
  int? amount;
  Party? party;
  String? description;
  String? refType;
  Nft? token;
  DateTime? createdOn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['amount'] = amount;
    map['description'] = description;
    map['ref_type'] = refType;
    if (party != null) {
      map['party'] = party?.toJson();
    }
    if (token != null) {
      map['token'] = token?.toJson();
    }
    map['created_on'] = createdOn;
    return map;
  }
}
