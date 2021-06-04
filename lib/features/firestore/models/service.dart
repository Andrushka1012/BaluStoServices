class Service {
  static const COLLECTION_NAME = 'services';

  late final String id;
  late final String userId;
  late final String serviceName;
  late final int moneyAmount;
  late final DateTime date;
  late final bool hasPhoto;

  Service({
    required this.userId,
    required this.serviceName,
    required this.moneyAmount,
    required this.date,
    required this.hasPhoto,
    String? id
  }): id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Service.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    serviceName = json['serviceName'];
    moneyAmount = json['moneyAmount'];
    date = DateTime.parse(json['date'] as String);
    hasPhoto = json['hasPhoto'] == true;
  }

  Map<String, Object?> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['serviceName'] = serviceName;
    map['moneyAmount'] = moneyAmount;
    map['date'] = date.toIso8601String();
    map['hasPhoto'] = hasPhoto;
    return map;
  }
}
