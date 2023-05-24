import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase.dart';
import '../firebase_collections.dart';

class FirebaseBloodReadingsService {
  Future<List<BloodReadingsDto>?> loadAllReadings({
    required String userId,
  }) async {
    final snapshot = await getBloodReadingsRef(userId).get();
    return snapshot.docs
        .map(
          (QueryDocumentSnapshot<BloodReadingsDto> docSnapshot) =>
              docSnapshot.data(),
        )
        .toList();
  }

  Future<BloodReadingsDto?> addNewReadings({
    required String userId,
    required DateTime date,
    required List<BloodParameterReadingDto> readings,
  }) async {
    final bloodReadingsRef = await getBloodReadingsRef(userId).add(
      BloodReadingsDto(
        userId: userId,
        date: date,
        readingDtos: readings,
      ),
    );
    final snapshot = await bloodReadingsRef.get();
    return snapshot.data();
  }
}
