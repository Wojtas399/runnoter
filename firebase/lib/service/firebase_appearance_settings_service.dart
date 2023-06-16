import '../firebase.dart';
import '../firebase_collections.dart';
import '../utils/utils.dart';

class FirebaseAppearanceSettingsService {
  Future<AppearanceSettingsDto?> loadSettingsByUserId({
    required String userId,
  }) async {
    final snapshot = await getAppearanceSettingsRef(userId).get();
    return snapshot.data();
  }

  Future<AppearanceSettingsDto?> addSettings({
    required AppearanceSettingsDto appearanceSettingsDto,
  }) async {
    final settingsRef = getAppearanceSettingsRef(appearanceSettingsDto.userId);
    await asyncOrSyncCall(
      () => settingsRef.set(appearanceSettingsDto),
    );
    final snapshot = await settingsRef.get();
    return snapshot.data();
  }

  Future<AppearanceSettingsDto?> updateSettings({
    required String userId,
    ThemeMode? themeMode,
    Language? language,
  }) async {
    final settingsRef = getAppearanceSettingsRef(userId);
    final jsonToUpdate = createAppearanceSettingsJsonToUpdate(
      themeMode: themeMode,
      language: language,
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
      () => getAppearanceSettingsRef(userId).delete(),
    );
  }
}
