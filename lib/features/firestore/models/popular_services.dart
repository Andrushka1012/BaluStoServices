class PopularService {
  late final String name;
  late final int? price;
  late final int popularity;

  static const String COLLECTION_NAME = 'popularServices';

  PopularService.fromJson(dynamic json) {
    name = json['name'];
    price = json['price'];
    popularity = json['popularity'] ?? 0;
  }

  Map<String, Object?> toJsonApi() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['price'] = price;
    map['popularity'] = popularity;
    return map;
  }
}