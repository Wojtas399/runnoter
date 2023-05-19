import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase_collections.dart';
import '../model/blood_test_parameter_dto.dart';

class FirebaseBloodTestParameterService {
  Future<List<BloodTestParameterDto>?> loadAllParameters({
    required String userId,
  }) async {
    final snapshot = await getBloodTestParametersRef(userId).get();
    return snapshot.docs
        .map(
          (QueryDocumentSnapshot<BloodTestParameterDto> docSnapshot) =>
              docSnapshot.data(),
        )
        .toList();
  }
}
