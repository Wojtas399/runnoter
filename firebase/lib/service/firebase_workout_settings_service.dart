import '../firebase.dart';
import '../firebase_collections.dart';

class FirebaseWorkoutSettingsService {
  Future<WorkoutSettingsDto?> loadSettingsByUserId({
    required String userId,
  }) async {
    final snapshot = await getWorkoutSettingsRef(userId).get();
    return snapshot.data();
  }

  Future<WorkoutSettingsDto?> addSettings({
    required WorkoutSettingsDto workoutSettingsDto,
  }) async {
    final settingsRef = getWorkoutSettingsRef(workoutSettingsDto.userId);
    await settingsRef.set(workoutSettingsDto);
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
    await settingsRef.update(jsonToUpdate);
    final snapshot = await settingsRef.get();
    return snapshot.data();
  }

  Future<void> deleteSettingsForUser({
    required String userId,
  }) async {
    await getWorkoutSettingsRef(userId).delete();
  }
}
