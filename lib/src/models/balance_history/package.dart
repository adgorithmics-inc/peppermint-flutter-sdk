class Package {
  Package({
    this.id,
    this.name,
    this.description,
    this.price,
    this.credits,
  });

  Package.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    credits = json['credits'];
  }
  String? id;
  String? name;
  String? description;
  int? price;
  int? credits;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['price'] = price;
    map['credits'] = credits;
    return map;
  }
}
