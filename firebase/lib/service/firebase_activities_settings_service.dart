import '../firebase.dart';
import '../firebase_collections.dart';
import '../utils/utils.dart';

class FirebaseActivitiesSettingsService {
  Future<WorkoutSettingsDto?> loadSettingsByUserId({
    required String userId,
  }) async {
    final snapshot = await getWorkoutSettingsRef(userId).get();
    return snapshot.data();
  }

  //TODO: Rename parameter to activitiesSettingsDto
  Future<WorkoutSettingsDto?> addSettings({
    required WorkoutSettingsDto workoutSettingsDto,
  }) async {
    final settingsRef = getWorkoutSettingsRef(workoutSettingsDto.userId);
    await asyncOrSyncCall(
      () => settingsRef.set(workoutSettingsDto),
    );
    final snapshot = await settingsRef.get();
    return snapshot.data();
  }

  Future<WorkoutSettingsDto?> updateSettings({
    required String userId,
    DistanceUnit? distanceUnit,
    PaceUnit? paceUnit,
  }) async {
    final settingsRef = getWorkoutSettingsRef(userId);
    final jsonToUpdate = createWorkoutSettingsJsonToUpdate(
      distanceUnit: distanceUnit,
      paceUnit: paceUnit,
    );
    await asyncOrSyncCall(
      () => settingsRef.update(jsonToUpdate),
    );
    final snapshot = await settingsRef.get();
    return snapshot.data();
  }

  Future<void> deleteSettingsForUser({
    required String userId,
  }) async {
    await asyncOrSyncCall(
      () => getWorkoutSettingsRef(userId).delete(),
    );
  }
}
