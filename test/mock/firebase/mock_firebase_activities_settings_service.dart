import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class FakeWorkoutSettingsDto extends Fake implements ActivitiesSettingsDto {}

class MockFirebaseActivitiesSettingsService extends Mock
    implements FirebaseActivitiesSettingsService {
  MockFirebaseActivitiesSettingsService() {
    registerFallbackValue(FakeWorkoutSettingsDto());
  }

  void mockLoadSettingsByUserId({
    ActivitiesSettingsDto? activitiesSettingsDto,
  }) {
    when(
      () => loadSettingsByUserId(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Future.value(activitiesSettingsDto));
  }

  void mockAddSettings({
    ActivitiesSettingsDto? activitiesSettingsDto,
  }) {
    when(
      () => addSettings(
        activitiesSettingsDto: any(named: 'activitiesSettingsDto'),
      ),
    ).thenAnswer((_) => Future.value(activitiesSettingsDto));
  }

  void mockUpdateSettings({
    ActivitiesSettingsDto? updatedActivitiesSettingsDto,
  }) {
    when(
      () => updateSettings(
        userId: any(named: 'userId'),
        distanceUnit: any(named: 'distanceUnit'),
        paceUnit: any(named: 'paceUnit'),
      ),
    ).thenAnswer((_) => Future.value(updatedActivitiesSettingsDto));
  }

  void mockDeleteSettingsForUser() {
    when(
      () => deleteSettingsForUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
