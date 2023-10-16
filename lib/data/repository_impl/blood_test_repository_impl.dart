import 'package:collection/collection.dart';
import 'package:firebase/firebase.dart' as firebase;

import '../../dependency_injection.dart';
import '../interface/repository/blood_test_repository.dart';
import '../mapper/blood_parameter_result_mapper.dart';
import '../mapper/blood_test_mapper.dart';
import '../mapper/custom_exception_mapper.dart';
import '../model/blood_test.dart';
import '../model/state_repository.dart';

class BloodTestRepositoryImpl extends StateRepository<BloodTest>
    implements BloodTestRepository {
  final firebase.FirebaseBloodTestService _dbBloodTestService;

  BloodTestRepositoryImpl({super.initialData})
      : _dbBloodTestService = getIt<firebase.FirebaseBloodTestService>();

  @override
  Stream<BloodTest?> getTestById({
    required String bloodTestId,
    required String userId,
  }) async* {
    await for (final bloodTests in dataStream$) {
      BloodTest? bloodTest = bloodTests?.firstWhereOrNull(
        (BloodTest test) => test.id == bloodTestId && test.userId == userId,
      );
      bloodTest ??= await _loadTestByIdFromDb(bloodTestId, userId);
      yield bloodTest;
    }
  }

  @override
  Stream<List<BloodTest>?> getTestsByUserId({required String userId}) async* {
    final testsLoadedFromDb = await _loadTestsByUserIdFromDb(userId);
    if (testsLoadedFromDb?.isNotEmpty == true) {
      addOrUpdateEntities(testsLoadedFromDb!);
    }
    await for (final readings in dataStream$) {
      yield readings?.where((bloodTest) => bloodTest.userId == userId).toList();
    }
  }

  @override
  Future<void> refreshTestsByUserId({required String userId}) async {
    final existingTests = await dataStream$.first;
    final userTestsLoadedFromDb = await _loadTestsByUserIdFromDb(userId);
    final List<BloodTest> updatedTests = [
      ...?existingTests?.where((test) => test.userId != userId),
      ...?userTestsLoadedFromDb,
    ];
    setEntities(updatedTests);
  }

  @override
  Future<void> addNewTest({
    required String userId,
    required DateTime date,
    required List<BloodParameterResult> parameterResults,
  }) async {
    final addedBloodTestDto = await _dbBloodTestService.addNewTest(
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
    try {
      final updatedTestDto = await _dbBloodTestService.updateTest(
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
    } on firebase.FirebaseDocumentException catch (documentException) {
      if (documentException.code ==
          firebase.FirebaseDocumentExceptionCode.documentNotFound) {
        removeEntity(bloodTestId);
      }
      throw mapExceptionFromDb(documentException);
    }
  }

  @override
  Future<void> deleteTest({
    required String bloodTestId,
    required String userId,
  }) async {
    await _dbBloodTestService.deleteTest(
      bloodTestId: bloodTestId,
      userId: userId,
    );
    removeEntity(bloodTestId);
  }

  @override
  Future<void> deleteAllUserTests({required String userId}) async {
    final List<String> idsOfDeletedTests =
        await _dbBloodTestService.deleteAllUserTests(userId: userId);
    removeEntities(idsOfDeletedTests);
  }

  Future<BloodTest?> _loadTestByIdFromDb(
    String bloodTestId,
    String userId,
  ) async {
    final bloodTestDto = await _dbBloodTestService.loadTestById(
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

  Future<List<BloodTest>?> _loadTestsByUserIdFromDb(String userId) async {
    final testsDtos = await _dbBloodTestService.loadTestsByUserId(
      userId: userId,
    );
    return testsDtos?.map(mapBloodTestFromDto).toList();
  }
}
