import 'package:balu_sto/features/firestore/models/service.dart';
import 'package:balu_sto/infrastructure/database/base_dao.dart';
import 'package:balu_sto/infrastructure/database/local_data_base.dart';

class ServicesDao extends BaseDao<Service, String> {
  static const POOL_NAME = 'Services';

  ServicesDao(LocalDatabase localDataBase) : super(localDataBase);

  @override
  String get poolName => POOL_NAME;

  @override
  String getItemKey(Service item) => item.id;

  @override
  Map<String, dynamic> itemToMap(Service item) => item.toJson();

  @override
  Service mapToItem(Map<String, dynamic> map) => Service.fromJson(map);
}
