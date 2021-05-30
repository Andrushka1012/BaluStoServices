import 'dart:async';

import 'package:sembast/sembast.dart';
import 'package:balu_sto/helpers/extensions/list_extensions.dart';
import 'package:balu_sto/helpers/extensions/stream_extensions.dart';

import 'local_data_base.dart';

abstract class BaseDao<T, K> {
  BaseDao(this._localDataBase);

  final LocalDatabase _localDataBase;

  Future<Database> get database => _localDataBase.database;

  StoreRef store = StoreRef<String, String>.main();

  abstract final String poolName;

  K getItemKey(T item);

  T mapToItem(Map<String, dynamic> map);

  Map<String, dynamic> itemToMap(T item);

  String _getObjectKey(K key) => '$poolName:$key';

  // Don't need to be closed, because dao is singleton working on app scope
  // ignore: close_sinks
  final StreamController<List<T>> _daoStreamController = StreamController.broadcast();

  Future<List<T>> getAll({List<SortOrder>? sortOrders}) async {
    final snapshot = await store.find(
      await database,
      finder: Finder(
        sortOrders: sortOrders,
        filter: Filter.custom(
          (record) => record.key.toString().contains(poolName),
        ),
      ),
    );
    return snapshot.map((item) => mapToItem(item.value as Map<String, dynamic>)).toList();
  }

  Future<T?> getBy(K key) async {
    final finder = Finder(filter: Filter.byKey(_getObjectKey(key)));
    final found = await store.find(await database, finder: finder);
    return found.isNotEmpty ? mapToItem(found.first.value as Map<String, dynamic>) : null;
  }

  Stream<List<T>> getAllStreamed() => _daoStreamController.stream;

  Stream<T> getStreamedBy(K key) => _daoStreamController.stream
      .map((items) => items.firstOrNull((item) => key == getItemKey(item)))
      .whereNotNull()
      .distinct((T previous, T next) => getItemKey(previous) == getItemKey(next));

  Future put(T item) async {
    final itemKey = _getObjectKey(getItemKey(item));
    store.record(itemKey).put(
          await database,
          itemToMap(item),
        );
    await notify();
  }

  Future remove(T item) => removeByKey(getItemKey(item));

  Future removeByKey(K key) async {
    final itemKey = _getObjectKey(key);
    await store.delete(
      await database,
      finder: Finder(
        filter: Filter.byKey(itemKey),
      ),
    );
    await notify();
  }

  Future removeAll({bool notifyListeners = true}) async {
    await store.delete(
      await database,
      finder: Finder(
        filter: Filter.custom(
          (record) => record.key.toString().contains(poolName),
        ),
      ),
    );
    if (notifyListeners) {
      await notify();
    }
  }

  Future notify() async {
    final results = await getAll();
    _daoStreamController.add(results);
  }
}
