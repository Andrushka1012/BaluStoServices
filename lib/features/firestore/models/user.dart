import 'package:balu_sto/features/firestore/models/role.dart';
import 'package:balu_sto/helpers/extensions/list_extensions.dart';

class AppUser {
  static const COLLECTION_NAME = 'users';

  late final String userId;
  String? documentId;
  late final String name;
  late final String email;
  late final Role role;
  late int debit;

  AppUser({
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
    required this.debit,
  });

  AppUser.fromJson(dynamic json) {
    userId = json['userId'];
    name = json['name'];
    email = json['email'];
    documentId = json['documentId'] ?? '';
    debit = json['debit'] ?? 0;
    role = Role.values.firstOrNull((element) => element.toString().contains(json['role'])) ?? Role.EMPLOYEE;
  }

  Map<String, Object?> toJsonApi() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['name'] = name;
    map['email'] = email;
    map['debit'] = debit;
    map['role'] = role == Role.ADMIN ? 'ADMIN' : 'EMPLOYEE';
    return map;
  }

}
