class Service {
  static const COLLECTION_NAME = 'services';

  late final String id;
  late final String userId;
  late final String serviceName;
  late final int moneyAmount;
  late final DateTime date;
  late final DateTime? modifiedDate;
  late final bool hasPhoto;

  ServiceLocalData? localData;

  Service({
    required this.userId,
    required this.serviceName,
    required this.moneyAmount,
    required this.date,
    required this.modifiedDate,
    required this.hasPhoto,
    String? id,
    this.localData,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Service.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    serviceName = json['serviceName'];
    moneyAmount = json['moneyAmount'];
    date = DateTime.parse(json['date'] as String);
    modifiedDate = json['modifiedDate'] != null ? DateTime.parse(json['modifiedDate'] as String) : null;
    hasPhoto = json['hasPhoto'] == true;
    localData = json['localData'] != null ? ServiceLocalData.fromJson(json['localData']) : null;
  }

  Map<String, Object?> toJsonApi() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['serviceName'] = serviceName;
    map['moneyAmount'] = moneyAmount;
    map['date'] = date.toIso8601String();
    map['modifiedDate'] = modifiedDate?.toIso8601String();
    map['hasPhoto'] = hasPhoto;
    return map;
  }

  Map<String, Object?> toJsonLocal() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['serviceName'] = serviceName;
    map['moneyAmount'] = moneyAmount;
    map['date'] = date.toIso8601String();
    map['modifiedDate'] = modifiedDate?.toIso8601String();
    map['hasPhoto'] = hasPhoto;
    map['localData'] = localData?.toJson();
    return map;
  }
}

class ServiceLocalData {
  String? filePath;
  String? documentId;
  late bool isUploaded;

  ServiceLocalData({
    required this.filePath,
    required this.isUploaded,
    required this.documentId,
  });

  ServiceLocalData.fromJson(dynamic json) {
    filePath = json['filePath'];
    isUploaded = json['isUploaded'];
    documentId = json['documentId'];
  }

  Map<String, Object?> toJson() {
    final map = <String, dynamic>{};
    map['filePath'] = filePath;
    map['isUploaded'] = isUploaded;
    map['documentId'] = documentId;
    return map;
  }
}
