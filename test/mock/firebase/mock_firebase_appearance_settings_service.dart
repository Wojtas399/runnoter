import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class FakeAppearanceSettingsDto extends Fake implements AppearanceSettingsDto {}

class MockFirebaseAppearanceSettingsService extends Mock
    implements FirebaseAppearanceSettingsService {
  void mockLoadSettingsByUserId({
    AppearanceSettingsDto? appearanceSettingsDto,
  }) {
    when(
      () => loadSettingsByUserId(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value(appearanceSettingsDto));
  }

  void mockAddSettings({
    AppearanceSettingsDto? appearanceSettingsDto,
  }) {
    _mockAppearanceSettingsDto();
    when(
      () => addSettings(
        appearanceSettingsDto: any(named: 'appearanceSettingsDto'),
      ),
    ).thenAnswer((invocation) => Future.value(appearanceSettingsDto));
  }

  void mockUpdateSettings({
    AppearanceSettingsDto? updatedAppearanceSettingsDto,
  }) {
    when(
      () => updateSettings(
        userId: any(named: 'userId'),
        themeMode: any(named: 'themeMode'),
        language: any(named: 'language'),
      ),
    ).thenAnswer((invocation) => Future.value(updatedAppearanceSettingsDto));
  }

  void mockDeleteSettingsForUser() {
    when(
      () => deleteSettingsForUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  void _mockAppearanceSettingsDto() {
    registerFallbackValue(FakeAppearanceSettingsDto());
  }
}
