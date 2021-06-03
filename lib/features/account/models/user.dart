import 'package:balu_sto/features/account/models/role.dart';
import 'package:balu_sto/helpers/extensions/list_extensions.dart';

class AppUser {
  static const COLLECTION_NAME = 'users';

  late final String userId;
  late final String name;
  late final String email;
  late final Role role;

  AppUser({
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
  });

  AppUser.fromJson(dynamic json) {
    userId = json['userId'];
    name = json['name'];
    email = json['email'];
    role = Role.values.firstOrNull((element) => element.toString().contains(json['role'])) ?? Role.EMPLOYEE;
  }

  Map<String, Object?> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['name'] = name;
    map['email'] = email;
    map['role'] = role == Role.ADMIN ? 'ADMIN' : 'EMPLOYEE';
    return map;
  }
}
