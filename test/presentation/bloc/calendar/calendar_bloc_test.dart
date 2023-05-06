import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/workout.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/calendar/bloc/calendar_bloc.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_workout_repository.dart';
import '../../../mock/presentation/service/mock_date_service.dart';

void main() {
  final dateService = MockDateService();
  final authService = MockAuthService();
  final workoutRepository = MockWorkoutRepository();

  CalendarBloc createBloc() => CalendarBloc(
        dateService: dateService,
        authService: authService,
        workoutRepository: workoutRepository,
      );

  CalendarState createState({
    BlocStatus status = const BlocStatusInitial(),
    List<Workout>? workouts,
    int? month,
    int? year,
  }) =>
      CalendarState(
        status: status,
        workouts: workouts,
        month: month,
        year: year,
      );

  blocTest(
    'initialize, '
    'should emit current month with year and should set listener of workouts from current month',
    build: () => createBloc(),
    setUp: () {
      dateService.mockGetTodayDate(
        todayDate: DateTime(2023, 1, 10),
      );
      dateService.mockGetFirstDateOfTheMonth(
        date: DateTime(2023, 1, 1),
      );
      dateService.mockGetLastDateOfTheMonth(
        date: DateTime(2023, 1, 31),
      );
      authService.mockGetLoggedUserId(userId: 'u1');
      workoutRepository.mockGetWorkoutsByDateRange(
        workouts: [],
      );
    },
    act: (CalendarBloc bloc) => bloc.add(
      const CalendarEventInitialize(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        month: 1,
        year: 2023,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.getWorkoutsByDateRange(
          startDate: DateTime(2023, 1, 1),
          endDate: DateTime(2023, 1, 31),
          userId: 'u1',
        ),
      ).called(1);
    },
  );
}
