import 'package:collection/collection.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:rxdart/rxdart.dart';

import '../../domain/model/blood_parameter.dart';
import '../../domain/model/blood_test.dart';
import '../../domain/model/state_repository.dart';
import '../../domain/repository/blood_test_repository.dart';
import '../mapper/blood_parameter_result_mapper.dart';
import '../mapper/blood_test_mapper.dart';

class BloodTestRepositoryImpl extends StateRepository<BloodTest>
    implements BloodTestRepository {
  final firebase.FirebaseBloodTestService _firebaseBloodTestService;

  BloodTestRepositoryImpl({
    required firebase.FirebaseBloodTestService firebaseBloodTestService,
    super.initialData,
  }) : _firebaseBloodTestService = firebaseBloodTestService;

  @override
  Stream<BloodTest?> getTestById({
    required String bloodTestId,
    required String userId,
  }) {
    return dataStream$
        .map(
          (List<BloodTest>? bloodTests) => bloodTests?.firstWhereOrNull(
            (BloodTest test) => test.id == bloodTestId && test.userId == userId,
          ),
        )
        .doOnListen(
          () => doesEntityNotExistInState(bloodTestId)
              ? _loadTestByIdFromRemoteDb(bloodTestId, userId)
              : null,
        );
  }

  @override
  Stream<List<BloodTest>?> getAllTests({
    required String userId,
  }) async* {
    await _loadTestsFromRemoteDb(userId);
    await for (final readings in dataStream$) {
      yield readings?.where((bloodTest) => bloodTest.userId == userId).toList();
    }
  }

  @override
  Future<void> addNewTest({
    required String userId,
    required DateTime date,
    required List<BloodParameterResult> parameterResults,
  }) async {
    final addedBloodTestDto = await _firebaseBloodTestService.addNewTest(
      userId: userId,
      date: date,
      parameterResultDtos:
          parameterResults.map(mapBloodParameterResultToDto).toList(),
    );
    if (addedBloodTestDto != null) {
      final BloodTest bloodTest = mapBloodTestFromDto(
        addedBloodTestDto,
      );
      addEntity(bloodTest);
    }
  }

  @override
  Future<void> updateTest({
    required String bloodTestId,
    required String userId,
    DateTime? date,
    List<BloodParameterResult>? parameterResults,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTest({
    required String bloodTestId,
    required String userId,
  }) async {
    await _firebaseBloodTestService.deleteTest(
      bloodTestId: bloodTestId,
      userId: userId,
    );
    removeEntity(bloodTestId);
  }

  Future<void> _loadTestByIdFromRemoteDb(
    String bloodTestId,
    String userId,
  ) async {
    final bloodTestDto = await _firebaseBloodTestService.loadTestById(
      bloodTestId: bloodTestId,
      userId: userId,
    );
    if (bloodTestDto != null) {
      final BloodTest bloodTest = mapBloodTestFromDto(bloodTestDto);
      addEntity(bloodTest);
    }
  }

  Future<void> _loadTestsFromRemoteDb(String userId) async {
    final testsDtos = await _firebaseBloodTestService.loadAllTests(
      userId: userId,
    );
    if (testsDtos != null) {
      final List<BloodTest> tests = testsDtos.map(mapBloodTestFromDto).toList();
      addEntities(tests);
    }
  }
}
