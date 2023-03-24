import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/model/entity.dart';
import 'package:runnoter/domain/model/state_repository.dart';

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
    'should add new entity to state',
    () async {
      const TestModel entity = TestModel(
        id: 'e',
        name: 'model name',
      );

      repository.addEntity(entity);

      expect(
        await repository.dataStream$.first,
        [entity],
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
}
