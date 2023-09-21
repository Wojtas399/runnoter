import 'package:rxdart/rxdart.dart';

import '../entity/entity.dart';

class StateRepository<T extends Entity> {
  final BehaviorSubject<List<T>?> _dataStream =
      BehaviorSubject<List<T>?>.seeded(null);

  StateRepository({List<T>? initialData}) {
    _dataStream.add(initialData);
  }

  Stream<List<T>?> get dataStream$ => _dataStream.stream;

  void close() {
    _dataStream.close();
  }

  bool doesEntityNotExistInState(String entityId) {
    for (final T entity in [...?_dataStream.value]) {
      if (entity.id == entityId) {
        return false;
      }
    }
    return true;
  }

  void addEntity(T entity) {
    final List<T> updatedData = [...?_dataStream.value];
    final List<String> idsOfExistingEntities = _getIdsOfExistingEntities();
    if (idsOfExistingEntities.contains(entity.id)) {
      final int entityIndex = updatedData.indexWhere(
        (element) => element.id == entity.id,
      );
      updatedData[entityIndex] = entity;
    } else {
      updatedData.add(entity);
    }
    _dataStream.add(updatedData);
  }

  void addOrUpdateEntities(List<T> entities) {
    if (entities.isEmpty) return;
    final List<T> updatedData = [...?_dataStream.value];
    final List<String> existingEntityIds = _getIdsOfExistingEntities();
    for (final T entity in entities) {
      if (existingEntityIds.contains(entity.id)) {
        final int entityIndex = updatedData.indexWhere(
          (element) => element.id == entity.id,
        );
        updatedData[entityIndex] = entity;
      } else {
        updatedData.add(entity);
      }
    }
    _dataStream.add(updatedData);
  }

  void updateEntity(T entity) {
    final List<T> updatedData = [...?_dataStream.value];
    final entityIndex = updatedData.indexWhere(
      (T existingEntity) => existingEntity.id == entity.id,
    );
    if (entityIndex < 0) {
      return;
    }
    updatedData[entityIndex] = entity;
    _dataStream.add(updatedData);
  }

  void removeEntity(String entityId) {
    final List<T> updatedData = [...?_dataStream.value];
    updatedData.removeWhere((entity) => entity.id == entityId);
    _dataStream.add(updatedData);
  }

  void removeEntities(List<String> idsOfEntities) {
    final List<T> updatedData = [...?_dataStream.value];
    for (final String entityId in idsOfEntities) {
      updatedData.removeWhere((entity) => entity.id == entityId);
    }
    _dataStream.add(updatedData);
  }

  List<String> _getIdsOfExistingEntities() =>
      [...?_dataStream.value].map((T entity) => entity.id).toList();
}
