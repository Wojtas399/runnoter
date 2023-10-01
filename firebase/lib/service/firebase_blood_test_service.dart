import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase.dart';
import '../firebase_collections.dart';
import '../utils/utils.dart';

class FirebaseBloodTestService {
  Future<BloodTestDto?> loadTestById({
    required String bloodTestId,
    required String userId,
  }) async {
    final snapshot = await getBloodTestsRef(userId).doc(bloodTestId).get();
    return snapshot.data();
  }

  Future<List<BloodTestDto>?> loadTestsByUserId({
    required String userId,
  }) async {
    final snapshot = await getBloodTestsRef(userId).get();
    return snapshot.docs
        .map(
          (QueryDocumentSnapshot<BloodTestDto> docSnapshot) =>
              docSnapshot.data(),
        )
        .toList();
  }

  Future<BloodTestDto?> addNewTest({
    required String userId,
    required DateTime date,
    required List<BloodParameterResultDto> parameterResultDtos,
  }) async {
    final bloodTestRef = getBloodTestsRef(userId).doc();
    final BloodTestDto bloodTestDto = BloodTestDto(
      id: '',
      userId: userId,
      date: date,
      parameterResultDtos: parameterResultDtos,
    );
    await asyncOrSyncCall(
      () => bloodTestRef.set(bloodTestDto),
    );
    final snapshot = await bloodTestRef.get();
    return snapshot.data();
  }

  Future<BloodTestDto?> updateTest({
    required String bloodTestId,
    required String userId,
    DateTime? date,
    List<BloodParameterResultDto>? parameterResultDtos,
  }) async {
    final bloodTestRef = getBloodTestsRef(userId).doc(bloodTestId);
    final Map<String, dynamic> jsonToUpdate = createBloodTestJsonToUpdate(
      date: date,
      parameterResultDtos: parameterResultDtos,
    );
    await asyncOrSyncCall(
      () => bloodTestRef.update(jsonToUpdate),
    );
    final snapshot = await bloodTestRef.get();
    return snapshot.data();
  }

  Future<void> deleteTest({
    required String bloodTestId,
    required String userId,
  }) async {
    await asyncOrSyncCall(
      () => getBloodTestsRef(userId).doc(bloodTestId).delete(),
    );
  }

  Future<List<String>> deleteAllUserTests({required String userId}) async {
    final bloodTestsRef = getBloodTestsRef(userId);
    final snapshot = await bloodTestsRef.get();
    final List<String> idsOfDeletedTests = [];
    final WriteBatch batch = FirebaseFirestore.instance.batch();
    for (final docSnapshot in snapshot.docs) {
      batch.delete(docSnapshot.reference);
      idsOfDeletedTests.add(docSnapshot.id);
    }
    await asyncOrSyncCall(
      () => batch.commit(),
    );
    return idsOfDeletedTests;
  }
}
