import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase.dart';
import '../firebase_collections.dart';

class FirebaseBloodReadingService {
  Future<List<BloodReadingDto>?> loadAllReadings({
    required String userId,
  }) async {
    final snapshot = await getBloodReadingsRef(userId).get();
    return snapshot.docs
        .map(
          (QueryDocumentSnapshot<BloodReadingDto> docSnapshot) =>
              docSnapshot.data(),
        )
        .toList();
  }

  Future<BloodReadingDto?> addNewReading({
    required String userId,
    required DateTime date,
    required List<BloodReadingParameterDto> parameters,
  }) async {
    final bloodReadingsRef = await getBloodReadingsRef(userId).add(
      BloodReadingDto(
        id: '',
        userId: userId,
        date: date,
        parameterDtos: parameters,
      ),
    );
    final snapshot = await bloodReadingsRef.get();
    return snapshot.data();
  }
}
