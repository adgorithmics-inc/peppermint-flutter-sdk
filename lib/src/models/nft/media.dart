class Media {
  Media({
    this.fileType,
    this.thumbnail,
    this.originalFilename,
    this.fileUrl,
    this.fileSize,
  });

  Media.fromJson(dynamic json) {
    fileType = json['file_type'];
    thumbnail = json['thumbnail'];
    originalFilename = json['original_filename'];
    fileUrl = json['file_url'];
    fileSize = json['file_size'];
  }
  String? fileType;
  String? thumbnail;
  String? originalFilename;
  String? fileUrl;
  int? fileSize;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['file_type'] = fileType;
    map['thumbnail'] = thumbnail;
    map['original_filename'] = originalFilename;
    map['file_url'] = fileUrl;
    map['file_size'] = fileSize;
    return map;
  }
}
