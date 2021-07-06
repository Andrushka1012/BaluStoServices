import 'package:balu_sto/features/firestore/models/service.dart';
import 'package:balu_sto/features/firestore/models/service_status.dart';
import 'package:balu_sto/features/firestore/models/user.dart';
import 'package:balu_sto/helpers/extensions/date_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionDetails {
  final WorkTransaction transaction;
  final List<AppUser> relatedUsers;
  final List<Service> relatedServices;

  TransactionDetails({
    required this.transaction,
    required this.relatedUsers,
    required this.relatedServices,
  });

  int get selectedAmount => relatedServices.fold(0, (previousValue, element) => previousValue + element.moneyAmount);
}

class WorkTransaction {
  WorkTransaction({
    String? id,
    required this.members,
    required this.date,
    required this.status,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  static const COLLECTION_NAME = 'transactions';

  late final String id;
  late final List<TransactionMember> members;
  late final DateTime date;
  late ServiceStatus status;

  String get formattedDate => date.formatted();

  int get servicesCount =>
      members.fold(0, (int previous, TransactionMember member) => previous + member.services.length);

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
    map['members'] = members.map((e) => e.toJsonApi()).toList();
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
    services = (json['services'] as Iterable).map((e) => e.toString()).toList();
  }

  Map<String, Object?> toJsonApi() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['services'] = services;
    return map;
  }
}

extension ServiceStatusExtesion on ServiceStatus {
  IconData get icon {
    switch (this) {
      case ServiceStatus.CONFIRMED:
        return Icons.done;
      default:
        return Icons.payments_outlined;
    }
  }

  String get translation {
    switch (this) {
      case ServiceStatus.CONFIRMED:
        return 'Принятая оплата';
      default:
        return 'Оплаченно';
    }
  }
}
