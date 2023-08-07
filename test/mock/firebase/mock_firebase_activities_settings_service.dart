import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class FakeWorkoutSettingsDto extends Fake implements WorkoutSettingsDto {}

class MockFirebaseActivitiesSettingsService extends Mock
    implements FirebaseActivitiesSettingsService {
  void mockLoadSettingsByUserId({
    WorkoutSettingsDto? workoutSettingsDto,
  }) {
    when(
      () => loadSettingsByUserId(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value(workoutSettingsDto));
  }

  //TODO: Rename it to activitiesSettingsDto
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
    WorkoutSettingsDto? updatedWorkoutSettingsDto,
  }) {
    when(
      () => updateSettings(
        userId: any(named: 'userId'),
        distanceUnit: any(named: 'distanceUnit'),
        paceUnit: any(named: 'paceUnit'),
      ),
    ).thenAnswer((invocation) => Future.value(updatedWorkoutSettingsDto));
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
