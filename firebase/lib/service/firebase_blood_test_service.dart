import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase.dart';
import '../firebase_collections.dart';

class FirebaseBloodTestService {
  Future<BloodTestDto?> loadTestById({
    required String bloodTestId,
    required String userId,
  }) async {
    final snapshot = await getBloodTestsRef(userId).doc(bloodTestId).get();
    return snapshot.data();
  }

  Future<List<BloodTestDto>?> loadAllTests({
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
    final bloodTestRef = await getBloodTestsRef(userId).add(
      BloodTestDto(
        id: '',
        userId: userId,
        date: date,
        parameterResultDtos: parameterResultDtos,
      ),
    );
    final snapshot = await bloodTestRef.get();
    return snapshot.data();
  }

  Future<void> deleteTest({
    required String bloodTestId,
    required String userId,
  }) async {
    await getBloodTestsRef(userId).doc(bloodTestId).delete();
  }
}
