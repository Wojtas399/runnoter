import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/bloc/current_week/current_week_cubit.dart';
import 'package:runnoter/domain/entity/run_status.dart';
import 'package:runnoter/domain/entity/workout_stage.dart';

import '../../../creators/race_creator.dart';
import '../../../creators/run_status_creator.dart';
import '../../../creators/workout_creator.dart';
import '../../../mock/common/mock_date_service.dart';
import '../../../mock/domain/repository/mock_race_repository.dart';
import '../../../mock/domain/repository/mock_workout_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final dateService = MockDateService();
  final authService = MockAuthService();
  final workoutRepository = MockWorkoutRepository();
  final raceRepository = MockRaceRepository();
  const String loggedUserId = 'u1';

  CurrentWeekCubit createCubit({
    List<Day>? days,
  }) {
    return CurrentWeekCubit(
      dateService: dateService,
      authService: authService,
      workoutRepository: workoutRepository,
      raceRepository: raceRepository,
      days: days,
    );
  }

  tearDown(() {
    reset(dateService);
    reset(authService);
    reset(workoutRepository);
    reset(raceRepository);
  });

  blocTest(
    'number of activities, '
    'should sum activities from all days',
    build: () => createCubit(
      days: [
        Day(date: DateTime(2023, 4, 3), isToday: false),
        Day(date: DateTime(2023, 4, 4), isToday: false),
        Day(
          date: DateTime(2023, 4, 5),
          isToday: true,
          workouts: [
            createWorkout(
              id: 'w1',
              date: DateTime(2023, 4, 5),
            ),
            createWorkout(
              id: 'w3',
              date: DateTime(2023, 4, 5),
            ),
          ],
          races: [
            createRace(
              id: 'c1',
              date: DateTime(2023, 4, 5),
            ),
          ],
        ),
        Day(
          date: DateTime(2023, 4, 6),
          isToday: false,
          races: [
            createRace(
              id: 'c2',
              date: DateTime(2023, 4, 6),
            ),
          ],
        ),
        Day(
          date: DateTime(2023, 4, 7),
          isToday: false,
          workouts: [
            createWorkout(
              id: 'w2',
              date: DateTime(2023, 4, 7),
            )
          ],
        ),
        Day(date: DateTime(2023, 4, 8), isToday: false),
        Day(date: DateTime(2023, 4, 9), isToday: false),
      ],
    ),
    verify: (bloc) => expect(bloc.numberOfActivities, 5),
  );

  blocTest(
    'scheduled total distance, '
    'should sum distance of all activities from all days',
    build: () => createCubit(
      days: [
        Day(date: DateTime(2023, 4, 3), isToday: false),
        Day(date: DateTime(2023, 4, 4), isToday: false),
        Day(
          date: DateTime(2023, 4, 5),
          isToday: true,
          workouts: [
            createWorkout(
              id: 'w1',
              date: DateTime(2023, 4, 5),
              stages: [
                const WorkoutStageCardio(
                  distanceInKm: 5.2,
                  maxHeartRate: 150,
                ),
              ],
            ),
            createWorkout(
              id: 'w3',
              date: DateTime(2023, 4, 5),
              stages: [
                const WorkoutStageCardio(
                  distanceInKm: 2.5,
                  maxHeartRate: 150,
                ),
              ],
            ),
          ],
          races: [
            createRace(
              id: 'c1',
              date: DateTime(2023, 4, 5),
              distance: 10.0,
            ),
          ],
        ),
        Day(
          date: DateTime(2023, 4, 6),
          isToday: false,
          races: [
            createRace(
              id: 'c2',
              date: DateTime(2023, 4, 6),
              distance: 2.0,
            ),
          ],
        ),
        Day(
          date: DateTime(2023, 4, 7),
          isToday: false,
          workouts: [
            createWorkout(
              id: 'w2',
              date: DateTime(2023, 4, 7),
              stages: [
                const WorkoutStageHillRepeats(
                  amountOfSeries: 10,
                  seriesDistanceInMeters: 200,
                  walkingDistanceInMeters: 100,
                  joggingDistanceInMeters: 200,
                ),
              ],
            )
          ],
        ),
        Day(date: DateTime(2023, 4, 8), isToday: false),
        Day(date: DateTime(2023, 4, 9), isToday: false),
      ],
    ),
    verify: (bloc) => expect(bloc.scheduledTotalDistance, 24.7),
  );

  blocTest(
    'covered total distance, '
    'should sum distance of covered distance of all activities from all days',
    build: () => createCubit(
      days: [
        Day(date: DateTime(2023, 4, 3), isToday: false),
        Day(date: DateTime(2023, 4, 4), isToday: false),
        Day(
          date: DateTime(2023, 4, 5),
          isToday: true,
          workouts: [
            createWorkout(
              id: 'w1',
              date: DateTime(2023, 4, 5),
              status: createRunStatusDone(coveredDistanceInKm: 5.2),
            ),
            createWorkout(
              id: 'w3',
              date: DateTime(2023, 4, 5),
              status: createRunStatusAborted(coveredDistanceInKm: 2.5),
            ),
          ],
          races: [
            createRace(
              id: 'c1',
              date: DateTime(2023, 4, 5),
              status: createRunStatusDone(coveredDistanceInKm: 10.0),
            ),
          ],
        ),
        Day(
          date: DateTime(2023, 4, 6),
          isToday: false,
          races: [
            createRace(
              id: 'c2',
              date: DateTime(2023, 4, 6),
              status: const RunStatusUndone(),
            ),
          ],
        ),
        Day(
          date: DateTime(2023, 4, 7),
          isToday: false,
          workouts: [
            createWorkout(
              id: 'w2',
              date: DateTime(2023, 4, 7),
              status: const RunStatusPending(),
            )
          ],
        ),
        Day(date: DateTime(2023, 4, 8), isToday: false),
        Day(date: DateTime(2023, 4, 9), isToday: false),
      ],
    ),
    verify: (bloc) => expect(bloc.coveredTotalDistance, 17.7),
  );

  blocTest(
    'initialize, '
    "should set listener of logged user's workouts and races from week and should set days from current week in state",
    build: () => createCubit(),
    setUp: () {
      dateService.mockGetToday(todayDate: DateTime(2023, 4, 5));
      dateService.mockGetFirstDayOfTheWeek(date: DateTime(2023, 4, 3));
      dateService.mockGetLastDayOfTheWeek(date: DateTime(2023, 4, 9));
      authService.mockGetLoggedUserId(userId: loggedUserId);
      workoutRepository.mockGetWorkoutsByDateRange(
        workouts: [
          createWorkout(id: 'w1', date: DateTime(2023, 4, 5)),
          createWorkout(id: 'w2', date: DateTime(2023, 4, 7)),
          createWorkout(id: 'w3', date: DateTime(2023, 4, 5)),
        ],
      );
      raceRepository.mockGetRacesByDateRange(
        races: [
          createRace(id: 'c1', date: DateTime(2023, 4, 5)),
          createRace(id: 'c2', date: DateTime(2023, 4, 6)),
        ],
      );
      dateService.mockGetDaysFromWeek(
        dates: [
          DateTime(2023, 4, 3),
          DateTime(2023, 4, 4),
          DateTime(2023, 4, 5),
          DateTime(2023, 4, 6),
          DateTime(2023, 4, 7),
          DateTime(2023, 4, 8),
          DateTime(2023, 4, 9),
        ],
      );
      dateService.mockAreDatesTheSame(expected: false);
      when(
        () => dateService.areDatesTheSame(
          DateTime(2023, 4, 5),
          DateTime(2023, 4, 5),
        ),
      ).thenReturn(true);
      when(
        () => dateService.areDatesTheSame(
          DateTime(2023, 4, 7),
          DateTime(2023, 4, 7),
        ),
      ).thenReturn(true);
      when(
        () => dateService.areDatesTheSame(
          DateTime(2023, 4, 6),
          DateTime(2023, 4, 6),
        ),
      ).thenReturn(true);
    },
    act: (cubit) => cubit.initialize(),
    expect: () => [
      [
        Day(date: DateTime(2023, 4, 3), isToday: false),
        Day(date: DateTime(2023, 4, 4), isToday: false),
        Day(
          date: DateTime(2023, 4, 5),
          isToday: true,
          workouts: [
            createWorkout(
              id: 'w1',
              date: DateTime(2023, 4, 5),
            ),
            createWorkout(
              id: 'w3',
              date: DateTime(2023, 4, 5),
            ),
          ],
          races: [
            createRace(
              id: 'c1',
              date: DateTime(2023, 4, 5),
            ),
          ],
        ),
        Day(
          date: DateTime(2023, 4, 6),
          isToday: false,
          races: [
            createRace(
              id: 'c2',
              date: DateTime(2023, 4, 6),
            ),
          ],
        ),
        Day(
          date: DateTime(2023, 4, 7),
          isToday: false,
          workouts: [
            createWorkout(
              id: 'w2',
              date: DateTime(2023, 4, 7),
            )
          ],
        ),
        Day(date: DateTime(2023, 4, 8), isToday: false),
        Day(date: DateTime(2023, 4, 9), isToday: false),
      ]
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => workoutRepository.getWorkoutsByDateRange(
          userId: loggedUserId,
          startDate: DateTime(2023, 4, 3),
          endDate: DateTime(2023, 4, 9),
        ),
      ).called(1);
      verify(
        () => raceRepository.getRacesByDateRange(
          userId: loggedUserId,
          startDate: DateTime(2023, 4, 3),
          endDate: DateTime(2023, 4, 9),
        ),
      ).called(1);
    },
  );
}
