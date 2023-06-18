import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/state_repository.dart';
import 'package:runnoter/domain/entity/entity.dart';

class TestModel extends Entity {
  final String name;

  const TestModel({
    required super.id,
    required this.name,
  });

  @override
  List<Object> get props => [
        id,
        name,
      ];
}

void main() {
  late StateRepository repository;

  StateRepository createRepository({
    List<TestModel>? initialData,
  }) {
    return StateRepository(initialData: initialData);
  }

  setUp(() {
    repository = createRepository();
  });

  test(
    'add entity, '
    'new entity does not exist in state, '
    'should add new entity to state',
    () async {
      final List<TestModel> existingEntities = [
        const TestModel(id: 'e1', name: 'first entity'),
        const TestModel(id: 'e2', name: 'second entity'),
      ];
      const TestModel entityToAdd = TestModel(
        id: 'e',
        name: 'model name',
      );
      repository = createRepository(initialData: existingEntities);

      repository.addEntity(entityToAdd);

      expect(
        await repository.dataStream$.first,
        [
          ...existingEntities,
          entityToAdd,
        ],
      );
    },
  );

  test(
    'add entity, '
    'new entity already exists in state, '
    'should update new entity in state',
    () async {
      final List<TestModel> existingEntities = [
        const TestModel(id: 'e1', name: 'first entity'),
        const TestModel(id: 'e2', name: 'second entity'),
      ];
      const TestModel entityToAdd = TestModel(
        id: 'e1',
        name: 'model name',
      );
      repository = createRepository(initialData: existingEntities);

      repository.addEntity(entityToAdd);

      expect(
        await repository.dataStream$.first,
        [
          entityToAdd,
          existingEntities[1],
        ],
      );
    },
  );

  test(
    'add entities, '
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

      repository.addEntities(entitiesToAdd);

      expect(
        await repository.dataStream$.first,
        [
          existingEntities.first,
          ...entitiesToAdd,
        ],
      );
    },
  );

  test(
    'update entity, '
    'should update entity in state',
    () async {
      const TestModel existingEntity = TestModel(
        id: 'e1',
        name: 'name',
      );
      const TestModel updatedEntity = TestModel(
        id: 'e1',
        name: 'update name',
      );
      repository = createRepository(
        initialData: [existingEntity],
      );

      repository.updateEntity(updatedEntity);

      expect(
        await repository.dataStream$.first,
        [updatedEntity],
      );
    },
  );

  test(
    'remove entity, '
    'should remove entity from state',
    () async {
      const List<TestModel> entities = [
        TestModel(id: 'e1', name: 'name1'),
        TestModel(id: 'e2', name: 'name2'),
        TestModel(id: 'e3', name: 'name3'),
      ];
      repository = createRepository(
        initialData: entities,
      );

      repository.removeEntity('e2');

      expect(
        await repository.dataStream$.first,
        [
          entities.first,
          entities.last,
        ],
      );
    },
  );

  test(
    'remove entities, '
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
      repository = createRepository(
        initialData: entities,
      );

      repository.removeEntities(idsOfEntitiesToRemove);

      expect(
        await repository.dataStream$.first,
        [
          entities[1],
          entities.last,
        ],
      );
    },
  );
}
