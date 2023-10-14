import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/additional_model/state_repository.dart';
import 'package:runnoter/data/entity/entity.dart';

class TestModel extends Entity {
  final String name;

  const TestModel({required super.id, required this.name});

  @override
  List<Object> get props => [id, name];
}

void main() {
  late StateRepository repository;

  StateRepository createRepository({List<TestModel>? initialData}) {
    return StateRepository(initialData: initialData);
  }

  setUp(() {
    repository = createRepository();
  });

  test(
    'doesEntityNotExistInState, '
    'should return true if there is no entity with matching id',
    () {
      final List<TestModel> existingEntities = [
        const TestModel(id: 'e1', name: 'first entity'),
        const TestModel(id: 'e2', name: 'second entity'),
      ];
      repository = createRepository(initialData: existingEntities);

      final bool result = repository.doesEntityNotExistInState('e3');

      expect(result, true);
    },
  );

  test(
    'doesEntityNotExistInState, '
    'should return false if entity with matching id exists in state',
    () {
      final List<TestModel> existingEntities = [
        const TestModel(id: 'e1', name: 'first entity'),
        const TestModel(id: 'e2', name: 'second entity'),
      ];
      repository = createRepository(initialData: existingEntities);

      final bool result = repository.doesEntityNotExistInState('e2');

      expect(result, false);
    },
  );

  test(
    'setEntities, '
    'should set given entities in state',
    () {
      final List<TestModel> existingEntities = [
        const TestModel(id: 'e1', name: 'first entity'),
        const TestModel(id: 'e2', name: 'second entity'),
      ];
      final List<TestModel> newEntities = [
        const TestModel(id: 'e1', name: 'first entity'),
        const TestModel(id: 'e3', name: 'third entity'),
        const TestModel(id: 'e4', name: 'fourth entity'),
      ];
      repository = createRepository(initialData: existingEntities);

      repository.setEntities(newEntities);

      expect(repository.dataStream$, emits(newEntities));
    },
  );

  test(
    'addEntity, '
    'new entity does not exist in state, '
    'should add new entity to state',
    () async {
      final List<TestModel> existingEntities = [
        const TestModel(id: 'e1', name: 'first entity'),
        const TestModel(id: 'e2', name: 'second entity'),
      ];
      const TestModel entityToAdd = TestModel(id: 'e', name: 'model name');
      repository = createRepository(initialData: existingEntities);

      repository.addEntity(entityToAdd);

      expect(
        repository.dataStream$,
        emits([...existingEntities, entityToAdd]),
      );
    },
  );

  test(
    'addEntity, '
    'new entity already exists in state, '
    'should update new entity in state',
    () async {
      final List<TestModel> existingEntities = [
        const TestModel(id: 'e1', name: 'first entity'),
        const TestModel(id: 'e2', name: 'second entity'),
      ];
      const TestModel entityToAdd = TestModel(id: 'e1', name: 'model name');
      repository = createRepository(initialData: existingEntities);

      repository.addEntity(entityToAdd);

      expect(
        repository.dataStream$,
        emits([entityToAdd, existingEntities[1]]),
      );
    },
  );

  test(
    'addErUpdateEntities, '
    'should add new entities and update existing entities',
    () async {
      final List<TestModel> existingEntities = [
        const TestModel(id: 'e1', name: 'first entity'),
        const TestModel(id: 'e2', name: 'second entity'),
      ];
      final List<TestModel> entitiesToAdd = [
        const TestModel(id: 'e2', name: 'entity 2'),
        const TestModel(id: 'e4', name: 'fourth entity'),
        const TestModel(id: 'e5', name: 'fifth entity'),
      ];
      repository = createRepository(initialData: existingEntities);

      repository.addOrUpdateEntities(entitiesToAdd);

      expect(
        repository.dataStream$,
        emits([existingEntities.first, ...entitiesToAdd]),
      );
    },
  );

  test(
    'updateEntity, '
    'should update entity in state',
    () async {
      const TestModel existingEntity = TestModel(id: 'e1', name: 'name');
      const TestModel updatedEntity = TestModel(id: 'e1', name: 'update name');
      repository = createRepository(initialData: [existingEntity]);

      repository.updateEntity(updatedEntity);

      expect(repository.dataStream$, emits([updatedEntity]));
    },
  );

  test(
    'removeEntity, '
    'should remove entity from state',
    () async {
      const List<TestModel> entities = [
        TestModel(id: 'e1', name: 'name1'),
        TestModel(id: 'e2', name: 'name2'),
        TestModel(id: 'e3', name: 'name3'),
      ];
      repository = createRepository(initialData: entities);

      repository.removeEntity('e2');

      expect(
        repository.dataStream$,
        emits([entities.first, entities.last]),
      );
    },
  );

  test(
    'removeEntities, '
    'should remove entities from state',
    () async {
      const List<String> idsOfEntitiesToRemove = ['e1', 'e3', 'e4'];
      const List<TestModel> entities = [
        TestModel(id: 'e1', name: 'name1'),
        TestModel(id: 'e2', name: 'name2'),
        TestModel(id: 'e3', name: 'name3'),
        TestModel(id: 'e4', name: 'name4'),
        TestModel(id: 'e5', name: 'name5'),
      ];
      repository = createRepository(initialData: entities);

      repository.removeEntities(idsOfEntitiesToRemove);

      expect(
        repository.dataStream$,
        emits([entities[1], entities.last]),
      );
    },
  );
}
