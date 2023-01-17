class ProfessionalRole {
  ProfessionalRole({
    this.publicId,
    this.role,
  });

  ProfessionalRole.fromJson(dynamic json) {
    publicId = json['public_id'];
    role = json['role'];
  }

  String? publicId;
  String? role;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['public_id'] = publicId;
    map['role'] = role;
    return map;
  }
}
