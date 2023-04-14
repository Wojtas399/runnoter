import 'package:firebase/firebase.dart';
import 'package:firebase/service/firebase_workout_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseWorkoutService extends Mock
    implements FirebaseWorkoutService {
  void mockLoadWorkoutsByUserIdAndDateRange({
    List<WorkoutDto>? workoutDtos,
  }) {
    when(
      () => loadWorkoutsByUserIdAndDateRange(
        userId: any(named: 'userId'),
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
      ),
    ).thenAnswer((invocation) => Future.value(workoutDtos));
  }
}
