import 'package:rxdart/rxdart.dart';

import 'entity.dart';

class StateRepository<T extends Entity> {
  final BehaviorSubject<List<T>?> _repositoryState$ =
      BehaviorSubject<List<T>?>.seeded(null);

  StateRepository({List<T>? initialData}) {
    _repositoryState$.add(initialData);
  }

  Stream<List<T>?> get repositoryState$ => _repositoryState$.stream;

  void close() {
    _repositoryState$.close();
  }

  bool doesEntityNotExistInState(String entityId) {
    for (final T entity in [...?_repositoryState$.value]) {
      if (entity.id == entityId) return false;
    }
    return true;
  }

  void setEntities(List<T> entities) {
    _repositoryState$.add(entities);
  }

  void addEntity(T entity) {
    final List<T> updatedData = [...?_repositoryState$.value];
    final List<String> idsOfExistingEntities = _getIdsOfExistingEntities();
    if (idsOfExistingEntities.contains(entity.id)) {
      final int entityIndex = updatedData.indexWhere(
        (element) => element.id == entity.id,
      );
      updatedData[entityIndex] = entity;
    } else {
      updatedData.add(entity);
    }
    _repositoryState$.add(updatedData);
  }

  void addOrUpdateEntities(List<T> entities) {
    if (entities.isEmpty) return;
    final List<T> updatedData = [...?_repositoryState$.value];
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
    _repositoryState$.add(updatedData);
  }

  void updateEntity(T entity) {
    final List<T> updatedData = [...?_repositoryState$.value];
    final entityIndex = updatedData.indexWhere(
      (T existingEntity) => existingEntity.id == entity.id,
    );
    if (entityIndex < 0) return;
    if (updatedData[entityIndex] != entity) {
      updatedData[entityIndex] = entity;
      _repositoryState$.add(updatedData);
    }
  }

  void removeEntity(String entityId) {
    final List<T> updatedData = [...?_repositoryState$.value];
    updatedData.removeWhere((entity) => entity.id == entityId);
    _repositoryState$.add(updatedData);
  }

  void removeEntities(List<String> idsOfEntities) {
    final List<T> updatedData = [...?_repositoryState$.value];
    for (final String entityId in idsOfEntities) {
      updatedData.removeWhere((entity) => entity.id == entityId);
    }
    _repositoryState$.add(updatedData);
  }

  List<String> _getIdsOfExistingEntities() =>
      [...?_repositoryState$.value].map((T entity) => entity.id).toList();
}
