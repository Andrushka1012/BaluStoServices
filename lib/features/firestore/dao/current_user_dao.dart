import 'package:balu_sto/features/firestore/models/user.dart';
import 'package:balu_sto/infrastructure/database/base_dao.dart';
import 'package:balu_sto/infrastructure/database/local_data_base.dart';

class CurrentUserDao extends BaseDao<AppUser, String> {
  static const POOL_NAME = 'CurrentUserPool';

  CurrentUserDao(LocalDatabase localDataBase) : super(localDataBase);

  @override
  String get poolName => POOL_NAME;

  Future<AppUser?> getCurrentUser() async {
    final userData = await getAll();

    return userData.isNotEmpty ? userData.first : null;
  }

  @override
  String getItemKey(AppUser item) => item.userId;

  @override
  Map<String, dynamic> itemToMap(AppUser item) => item.toJsonLocal();

  @override
  AppUser mapToItem(Map<String, dynamic> map) => AppUser.fromJson(map);
}
