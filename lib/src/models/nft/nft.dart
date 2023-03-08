import 'contract.dart';
import 'media.dart';
import 'metadata_attributes.dart';
import 'network.dart';
import 'nft_owner.dart';
import 'series.dart';
import 'social.dart';

class Nft {
  Nft.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    tokenId = json['token_id'];
    series = json['series'] != null ? Series.fromJson(json['series']) : null;
    contract =
        json['contract'] != null ? Contract.fromJson(json['contract']) : null;
    network =
        json['network'] != null ? Network.fromJson(json['network']) : null;
    attributes =
        json['attributes'] != null ? json['attributes'].cast<int>() : [];
    metadataAttributes = [];
    if (json['metadata_attributes'] != null) {
      json['metadata_attributes'].forEach((v) {
        metadataAttributes.add(MetadataAttributes.fromJson(v));
      });
    }
    owner = json['owner'];
    status = json['status'];
    mintedOn = json['minted_on'] == null
        ? null
        : DateTime.parse('${json['minted_on']}+0000').toLocal();
    transactionId = json['transaction_id'];
    render = json['render'];
    tokenMetadataUrl = json['token_metadata_url'];
    contractMetadataUrl = json['contract_metadata_url'];
    createdOn = json['creation_on'] == null
        ? null
        : DateTime.parse('${json['creation_on']}+0000').toLocal();
    updatedOn = json['updated_on'] == null
        ? null
        : DateTime.parse('${json['updated_on']}+0000').toLocal();
    ;
    openSeaUrl = json['opensea_url'];
    description = json['description'];
    user = json['user'] != null ? NftOwner.fromJson(json['user']) : null;
    liked = json['liked'] ?? false;
    supported = json['supported'] ?? false;
    social = json['social'] != null ? Social.fromJson(json['social']) : null;
    media = json['media'] != null ? Media.fromJson(json['media']) : null;
    promoted = json['promoted'] ?? false;
    promotedOn = json['promoted_on'] == null
        ? null
        : DateTime.parse('${json['promoted_on']}+0000').toLocal();
  }

  String? id;
  String? name;
  int? tokenId;
  Series? series;
  Contract? contract;
  Network? network;
  List<int>? attributes;
  late List<MetadataAttributes> metadataAttributes;
  String? owner;
  String? status;
  DateTime? mintedOn;
  String? transactionId;
  String? render;
  String? tokenMetadataUrl;
  String? contractMetadataUrl;
  DateTime? createdOn;
  DateTime? updatedOn;
  String? openSeaUrl;
  String? description;
  NftOwner? user;
  late bool liked = false;
  late bool promoted = false;
  late bool supported = false;
  Social? social;
  Media? media;
  DateTime? promotedOn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['token_id'] = tokenId;
    if (series != null) {
      map['series'] = series?.toJson();
    }
    if (contract != null) {
      map['contract'] = contract?.toJson();
    }
    if (network != null) {
      map['network'] = network?.toJson();
    }
    if (social != null) {
      map['social'] = social?.toJson();
    }
    if (media != null) {
      map['media'] = media?.toJson();
    }
    map['attributes'] = attributes;
    map['metadata_attributes'] =
        metadataAttributes.map((v) => v.toJson()).toList();

    map['owner'] = owner;
    map['status'] = status;
    map['minted_on'] = mintedOn?.toIso8601String();
    map['transaction_id'] = transactionId;
    map['render'] = render;
    map['token_metadata_url'] = tokenMetadataUrl;
    map['contract_metadata_url'] = contractMetadataUrl;
    map['created_on'] = createdOn?.toIso8601String();
    map['updated_on'] = updatedOn?.toIso8601String();
    map['promoted'] = promoted;
    map['promoted_on'] = promotedOn?.toIso8601String();

    return map;
  }
}
