import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase.dart';
import '../firebase_collections.dart';
import '../mapper/custom_firebase_exception_mapper.dart';
import '../mapper/date_mapper.dart';
import '../utils/utils.dart';

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
    return snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  Future<WorkoutDto?> loadWorkoutById({
    required String workoutId,
    required String userId,
  }) async {
    final snapshot = await getWorkoutsRef(userId).doc(workoutId).get();
    return snapshot.data();
  }

  Future<List<WorkoutDto>?> loadWorkoutsByDate({
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
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<WorkoutDto>?> loadAllWorkouts({required String userId}) async {
    final snapshot = await getWorkoutsRef(userId).get();
    return snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  Future<WorkoutDto?> addWorkout({
    required String userId,
    required String workoutName,
    required DateTime date,
    required ActivityStatusDto status,
    required List<WorkoutStageDto> stages,
  }) async {
    final workoutRef = getWorkoutsRef(userId).doc();
    final WorkoutDto workoutDto = WorkoutDto(
      id: '',
      userId: userId,
      date: date,
      status: status,
      name: workoutName,
      stages: stages,
    );
    await asyncOrSyncCall(() => workoutRef.set(workoutDto));
    final snapshot = await workoutRef.get();
    return snapshot.data();
  }

  Future<WorkoutDto?> updateWorkout({
    required String workoutId,
    required String userId,
    DateTime? date,
    String? workoutName,
    ActivityStatusDto? status,
    List<WorkoutStageDto>? stages,
  }) async {
    try {
      final workoutRef = getWorkoutsRef(userId).doc(workoutId);
      final workoutJsonToUpdate = createWorkoutJsonToUpdate(
        date: date,
        workoutName: workoutName,
        status: status,
        stages: stages,
      );
      await asyncOrSyncCall(() => workoutRef.update(workoutJsonToUpdate));
      final snapshot = await workoutRef.get();
      return snapshot.data();
    } on FirebaseException catch (exception) {
      throw mapFirebaseExceptionFromCodeStr(exception.code);
    } catch (exception) {
      if (exception.toString().contains('code=not-found')) {
        throw mapFirebaseExceptionFromCodeStr('not-found');
      } else {
        rethrow;
      }
    }
  }

  Future<void> deleteWorkout({
    required String userId,
    required String workoutId,
  }) async {
    await asyncOrSyncCall(() => getWorkoutsRef(userId).doc(workoutId).delete());
  }

  Future<List<String>> deleteAllUserWorkouts({
    required String userId,
  }) async {
    final workoutsRef = getWorkoutsRef(userId);
    final WriteBatch batch = FirebaseFirestore.instance.batch();
    final snapshot = await workoutsRef.get();
    final List<String> idsOfDeletedWorkouts = [];
    for (final docSnapshot in snapshot.docs) {
      batch.delete(docSnapshot.reference);
      idsOfDeletedWorkouts.add(docSnapshot.id);
    }
    await asyncOrSyncCall(() => batch.commit());
    return idsOfDeletedWorkouts;
  }
}
