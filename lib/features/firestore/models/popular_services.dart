class PopularServices {
  late final String name;
  late final double? price;
  late final int? popularity;

  static const String COLLECTION_NAME = 'popularServices';

  PopularServices.fromJson(dynamic json) {
    name = json['name'];
    price = json['price'];
    popularity = json['popularity'] ?? -1;
  }

  Map<String, Object?> toJsonApi() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['price'] = price;
    map['popularity'] = popularity;
    return map;
  }
}