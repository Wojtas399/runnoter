import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase.dart';
import '../firebase_collections.dart';
import '../mapper/date_mapper.dart';

class FirebaseWorkoutService {
  Future<List<WorkoutDto>?> loadWorkoutsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required String userId,
  }) async {
    final snapshot = await getWorkoutsRef(userId)
        .where(
          workoutDtoDateField,
          isGreaterThanOrEqualTo: mapDateTimeToString(startDate),
        )
        .where(
          workoutDtoDateField,
          isLessThanOrEqualTo: mapDateTimeToString(endDate),
        )
        .get();
    return snapshot.docs
        .map(
          (QueryDocumentSnapshot<WorkoutDto> docSnapshot) => docSnapshot.data(),
        )
        .toList();
  }

  Future<WorkoutDto?> loadWorkoutById({
    required String workoutId,
    required String userId,
  }) async {
    final snapshot = await getWorkoutsRef(userId).doc(workoutId).get();
    return snapshot.data();
  }

  Future<WorkoutDto?> loadWorkoutByDate({
    required DateTime date,
    required String userId,
  }) async {
    final snapshot = await getWorkoutsRef(userId)
        .where(
          workoutDtoDateField,
          isEqualTo: mapDateTimeToString(date),
        )
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) {
      return null;
    }
    return snapshot.docs.first.data();
  }

  Future<List<WorkoutDto>?> loadAllWorkouts({
    required String userId,
  }) async {
    final snapshot = await getWorkoutsRef(userId).get();
    return snapshot.docs
        .map(
          (QueryDocumentSnapshot<WorkoutDto> docSnapshot) => docSnapshot.data(),
        )
        .toList();
  }

  Future<WorkoutDto?> addWorkout({
    required String userId,
    required String workoutName,
    required DateTime date,
    required RunStatusDto status,
    required List<WorkoutStageDto> stages,
  }) async {
    final workoutRef = await getWorkoutsRef(userId).add(
      WorkoutDto(
        id: '',
        userId: userId,
        date: date,
        status: status,
        name: workoutName,
        stages: stages,
      ),
    );
    final snapshot = await workoutRef.get();
    return snapshot.data();
  }

  Future<WorkoutDto?> updateWorkout({
    required String workoutId,
    required String userId,
    String? workoutName,
    RunStatusDto? status,
    List<WorkoutStageDto>? stages,
  }) async {
    final workoutRef = getWorkoutsRef(userId).doc(workoutId);
    final workoutJsonToUpdate = createWorkoutJsonToUpdate(
      workoutName: workoutName,
      status: status,
      stages: stages,
    );
    await workoutRef.update(workoutJsonToUpdate);
    final snapshot = await workoutRef.get();
    return snapshot.data();
  }

  Future<void> deleteWorkout({
    required String userId,
    required String workoutId,
  }) async {
    await getWorkoutsRef(userId).doc(workoutId).delete();
  }

  Future<List<String>> deleteAllUserWorkouts({
    required String userId,
  }) async {
    final CollectionReference<WorkoutDto> workoutsRef = getWorkoutsRef(userId);
    final WriteBatch batch = FirebaseFirestore.instance.batch();
    final snapshot = await workoutsRef.get();
    final List<String> idsOfDeletedWorkouts = [];
    for (final docSnapshot in snapshot.docs) {
      batch.delete(docSnapshot.reference);
      idsOfDeletedWorkouts.add(docSnapshot.id);
    }
    await batch.commit();
    return idsOfDeletedWorkouts;
  }
}
