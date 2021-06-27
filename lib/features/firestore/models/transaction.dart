import 'package:balu_sto/features/firestore/models/service_status.dart';
import 'package:balu_sto/helpers/extensions/date_extensions.dart';

class WorkTransaction {
  WorkTransaction({
    String? id,
    required this.members,
    required this.date,
    required this.status,
  }): id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  static const COLLECTION_NAME = 'services';

  late final String id;
  late final List<TransactionMember> members;
  late final DateTime date;
  late ServiceStatus status;

  String get formattedDate => date.formatted();

  WorkTransaction.fromJson(dynamic json) {
    id = json['id'];
    members = (json['members'] as Iterable).map((json) => TransactionMember.fromJson(json)).toList();
    date = DateTime.parse(json['date'] as String);
    status = ServiceStatusExtenion.create(json['status']);
  }

  Map<String, Object?> toJsonApi() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['date'] = date.toIso8601String();
    map['members'] = members.map((e) => e.toJsonApi());
    map['status'] = status.value;
    return map;
  }
}

class TransactionMember {
  TransactionMember({
    required this.userId,
    required this.services,
  });

  late final String userId;
  late final List<String> services;

  TransactionMember.fromJson(dynamic json) {
    userId = json['userId'];
    services = json['date'];
  }

  Map<String, Object?> toJsonApi() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['services'] = services;
    return map;
  }
}
