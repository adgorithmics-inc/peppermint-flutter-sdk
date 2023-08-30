import 'network.dart';

class Contract {
  Contract({
    this.name,
    this.network,
    this.address,
    this.id,
    this.status,
    this.createdOn,
    this.updatedOn,
    this.thumbnail,
    this.type,
  });

  Contract.fromJson(dynamic json) {
    name = json['name'];
    network =
        json['network'] != null ? Network.fromJson(json['network']) : null;
    address = json['address'];
    id = json['id'];
    status = json['status'];
    createdOn = json['created_on'];
    updatedOn = json['updated_on'];
    thumbnail = json['thumbnail'];
    type = json['type'];
  }

  String? name;
  Network? network;
  String? address;
  String? id;
  String? status;
  String? createdOn;
  String? updatedOn;
  String? type;
  dynamic thumbnail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    if (network != null) {
      map['network'] = network?.toJson();
    }
    map['address'] = address;
    map['id'] = id;
    map['status'] = status;
    map['created_on'] = createdOn;
    map['updated_on'] = updatedOn;
    map['thumbnail'] = thumbnail;
    return map;
  }
}
