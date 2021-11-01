import 'package:balu_sto/features/firestore/models/service_status.dart';
import 'package:balu_sto/helpers/extensions/date_extensions.dart';

class Service {
  Service({
    required this.userId,
    required this.serviceName,
    required this.moneyAmount,
    required this.date,
    required this.modifiedDate,
    required this.hasPhoto,
    required this.status,
    String? id,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
  static const COLLECTION_NAME = 'services';

  late final String id;
  late final String userId;
  late final String serviceName;
  late final int moneyAmount;
  late final DateTime date;
  late final DateTime? modifiedDate;
  late final bool hasPhoto;
  late ServiceStatus status;

  String? get photoUrl => hasPhoto
      ? 'https://firebasestorage.googleapis.com/v0/b/balustoservices.appspot.com/o/services%2F$id?alt=media'
      : null;

  String get formattedDate => date.formatted();

  String? get formattedModifiedDate => modifiedDate?.formatted();

  Service.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    serviceName = json['serviceName'];
    moneyAmount = json['moneyAmount'];
    date = DateTime.parse(json['date'] as String);
    modifiedDate = json['modifiedDate'] != null ? DateTime.parse(json['modifiedDate'] as String) : null;
    hasPhoto = json['hasPhoto'] == true;
    status = ServiceStatusExtenion.create(json['status']);
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
    map['status'] = status.value;
    return map;
  }
}
