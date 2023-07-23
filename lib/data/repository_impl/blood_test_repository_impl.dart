import 'package:collection/collection.dart';
import 'package:firebase/firebase.dart' as firebase;

import '../../dependency_injection.dart';
import '../../domain/additional_model/state_repository.dart';
import '../../domain/entity/blood_parameter.dart';
import '../../domain/entity/blood_test.dart';
import '../../domain/repository/blood_test_repository.dart';
import '../mapper/blood_parameter_result_mapper.dart';
import '../mapper/blood_test_mapper.dart';

class BloodTestRepositoryImpl extends StateRepository<BloodTest>
    implements BloodTestRepository {
  final firebase.FirebaseBloodTestService _firebaseBloodTestService;

  BloodTestRepositoryImpl({
    super.initialData,
  }) : _firebaseBloodTestService = getIt<firebase.FirebaseBloodTestService>();

  @override
  Stream<BloodTest?> getTestById({
    required String bloodTestId,
    required String userId,
  }) async* {
    await for (final bloodTests in dataStream$) {
      BloodTest? bloodTest = bloodTests?.firstWhereOrNull(
        (BloodTest test) => test.id == bloodTestId && test.userId == userId,
      );
      bloodTest ??= await _loadTestByIdFromRemoteDb(bloodTestId, userId);
      yield bloodTest;
    }
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
      final BloodTest bloodTest = mapBloodTestFromDto(addedBloodTestDto);
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
    final updatedTestDto = await _firebaseBloodTestService.updateTest(
      bloodTestId: bloodTestId,
      userId: userId,
      date: date,
      parameterResultDtos:
          parameterResults?.map(mapBloodParameterResultToDto).toList(),
    );
    if (updatedTestDto != null) {
      final BloodTest updatedTest = mapBloodTestFromDto(updatedTestDto);
      updateEntity(updatedTest);
    }
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

  @override
  Future<void> deleteAllUserTests({
    required String userId,
  }) async {
    final List<String> idsOfDeletedTests =
        await _firebaseBloodTestService.deleteAllUserTests(userId: userId);
    removeEntities(idsOfDeletedTests);
  }

  Future<BloodTest?> _loadTestByIdFromRemoteDb(
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
      return bloodTest;
    }
    return null;
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
