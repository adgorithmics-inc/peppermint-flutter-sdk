class MetadataAttributes {
  MetadataAttributes({
    this.traitType,
    this.value,
  });

  MetadataAttributes.fromJson(dynamic json) {
    traitType = json['trait_type'];
    value = json['value'];
  }
  String? traitType;
  String? value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['trait_type'] = traitType;
    map['value'] = value;
    return map;
  }
}
