import '../firebase.dart';
import '../firebase_collections.dart';
import '../utils/utils.dart';

class FirebaseActivitiesSettingsService {
  Future<ActivitiesSettingsDto?> loadSettingsByUserId({
    required String userId,
  }) async {
    final snapshot = await getActivitiesSettingsRef(userId).get();
    return snapshot.data();
  }

  Future<ActivitiesSettingsDto?> addSettings({
    required ActivitiesSettingsDto activitiesSettingsDto,
  }) async {
    final settingsRef = getActivitiesSettingsRef(activitiesSettingsDto.userId);
    await asyncOrSyncCall(() => settingsRef.set(activitiesSettingsDto));
    final snapshot = await settingsRef.get();
    return snapshot.data();
  }

  Future<ActivitiesSettingsDto?> updateSettings({
    required String userId,
    DistanceUnit? distanceUnit,
    PaceUnit? paceUnit,
  }) async {
    final settingsRef = getActivitiesSettingsRef(userId);
    final jsonToUpdate = createActivitiesSettingsJsonToUpdate(
      distanceUnit: distanceUnit,
      paceUnit: paceUnit,
    );
    await asyncOrSyncCall(() => settingsRef.update(jsonToUpdate));
    final snapshot = await settingsRef.get();
    return snapshot.data();
  }

  Future<void> deleteSettingsForUser({
    required String userId,
  }) async {
    await asyncOrSyncCall(() => getActivitiesSettingsRef(userId).delete());
  }
}
