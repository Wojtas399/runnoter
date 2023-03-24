import 'package:rxdart/rxdart.dart';

import 'entity.dart';

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
    updatedData.add(entity);
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
}
