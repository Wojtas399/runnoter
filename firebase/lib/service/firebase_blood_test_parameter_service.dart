import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase_collections.dart';
import '../model/blood_test_parameter_dto.dart';

class FirebaseBloodTestParameterService {
  Future<List<BloodTestParameterDto>?> loadAllParameters() async {
    final snapshot = await getBloodTestParametersRef().get();
    return snapshot.docs
        .map(
          (QueryDocumentSnapshot<BloodTestParameterDto> docSnapshot) =>
              docSnapshot.data(),
        )
        .toList();
  }
}
