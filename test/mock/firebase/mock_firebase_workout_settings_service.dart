import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class FakeWorkoutSettingsDto extends Fake implements WorkoutSettingsDto {}

class MockFirebaseWorkoutSettingsService extends Mock
    implements FirebaseWorkoutSettingsService {
  void mockLoadSettingsByUserId({
    WorkoutSettingsDto? workoutSettingsDto,
  }) {
    when(
      () => loadSettingsByUserId(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value(workoutSettingsDto));
  }

  void mockAddSettings({
    WorkoutSettingsDto? workoutSettingsDto,
  }) {
    _mockWorkoutSettingsDto();
    when(
      () => addSettings(
        workoutSettingsDto: any(named: 'workoutSettingsDto'),
      ),
    ).thenAnswer((invocation) => Future.value(workoutSettingsDto));
  }

  void mockUpdateSettings({
    WorkoutSettingsDto? updateWorkoutSettingsDto,
  }) {
    when(
      () => updateSettings(
        userId: any(named: 'userId'),
        distanceUnit: any(named: 'distanceUnit'),
        paceUnit: any(named: 'paceUnit'),
      ),
    ).thenAnswer((invocation) => Future.value(updateWorkoutSettingsDto));
  }

  void mockDeleteSettingsForUser() {
    when(
      () => deleteSettingsForUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  void _mockWorkoutSettingsDto() {
    registerFallbackValue(FakeWorkoutSettingsDto());
  }
}
