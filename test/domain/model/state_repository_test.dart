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
        id: 'model1',
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
    'add entity, '
    'there is already entity with given id in state, '
    'should update existing entity',
    () async {
      const TestModel existingEntity = TestModel(
        id: 'model1',
        name: 'model name',
      );
      const TestModel newEntity = TestModel(
        id: 'model1',
        name: 'new model name',
      );
      repository = createRepository(initialData: [existingEntity]);

      repository.addEntity(newEntity);

      expect(
        await repository.dataStream$.first,
        [newEntity],
      );
    },
  );
}
