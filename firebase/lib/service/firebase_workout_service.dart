import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase.dart';
import '../mapper/date_mapper.dart';
import '../model/workout_dto.dart';

class FirebaseWorkoutService {
  Future<List<WorkoutDto>?> loadWorkoutsByUserIdAndDateRange({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final snapshot = await getWorkoutsRef(userId)
        .where('field')
        .where(
          'date',
          isGreaterThanOrEqualTo: mapDateTimeToString(startDate),
        )
        .where(
          'date',
          isLessThanOrEqualTo: mapDateTimeToString(endDate),
        )
        .get();
    return snapshot.docs
        .map(
          (QueryDocumentSnapshot<WorkoutDto> docSnapshot) => docSnapshot.data(),
        )
        .toList();
  }
}
