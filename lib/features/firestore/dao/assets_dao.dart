import 'package:balu_sto/infrastructure/database/base_dao.dart';
import 'package:balu_sto/infrastructure/database/local_data_base.dart';

class AssetsDao extends BaseDao<AssetModel, String> {
  static const POOL_NAME = 'AssetModelPool';

  AssetsDao(LocalDatabase localDataBase) : super(localDataBase);

  @override
  String get poolName => POOL_NAME;

  @override
  String getItemKey(AssetModel item) => item.assetPath;

  @override
  Map<String, dynamic> itemToMap(AssetModel item) => item.toJson();

  @override
  AssetModel mapToItem(Map<String, dynamic> map) => AssetModel.fromJson(map);
}

class AssetModel {
  AssetModel({
    required this.assetPath,
    required this.filePath,
  });

  late final String assetPath;
  late final String filePath;

  AssetModel.fromJson(dynamic json) {
    assetPath = json['assetPath'];
    filePath = json['filePath'];
  }

  Map<String, Object?> toJson() {
    final map = <String, dynamic>{};
    map['assetPath'] = assetPath;
    map['filePath'] = filePath;
    return map;
  }
}
