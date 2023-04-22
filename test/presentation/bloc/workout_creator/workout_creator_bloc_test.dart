import 'package:bloc_test/bloc_test.dart';
import 'package:runnoter/domain/model/workout_stage.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/workout_creator/bloc/workout_creator_bloc.dart';

void main() {
  WorkoutCreatorBloc createBloc({
    List<WorkoutStage> stages = const [],
  }) =>
      WorkoutCreatorBloc(
        stages: stages,
      );

  WorkoutCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    DateTime? date,
    String? workoutName,
    List<WorkoutStage> stages = const [],
  }) =>
      WorkoutCreatorState(
        status: status,
        date: date,
        workoutName: workoutName,
        stages: stages,
      );

  blocTest(
    'initialize, '
    'should update date in state',
    build: () => createBloc(),
    act: (WorkoutCreatorBloc bloc) {
      bloc.add(
        WorkoutCreatorEventInitialize(
          date: DateTime(2023, 1, 1),
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        date: DateTime(2023, 1, 1),
      ),
    ],
  );

  blocTest(
    'workout name changed, '
    'should update workout name in state',
    build: () => createBloc(),
    act: (WorkoutCreatorBloc bloc) {
      bloc.add(
        const WorkoutCreatorEventWorkoutNameChanged(
          workoutName: 'new workout name',
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        workoutName: 'new workout name',
      ),
    ],
  );

  blocTest(
    'workout stage added, '
    'should add workout stage to existing stages',
    build: () => createBloc(
      stages: [
        WorkoutStageBaseRun(
          distanceInKilometers: 2,
          maxHeartRate: 150,
        ),
      ],
    ),
    act: (WorkoutCreatorBloc bloc) {
      bloc.add(
        WorkoutCreatorEventWorkoutStageAdded(
          workoutStage: WorkoutStageZone2(
            distanceInKilometers: 5,
            maxHeartRate: 165,
          ),
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        stages: [
          WorkoutStageBaseRun(
            distanceInKilometers: 2,
            maxHeartRate: 150,
          ),
          WorkoutStageZone2(
            distanceInKilometers: 5,
            maxHeartRate: 165,
          ),
        ],
      ),
    ],
  );

  blocTest(
    'workout stages order changed, '
    'should update list of workout stages in state',
    build: () => createBloc(
      stages: [
        WorkoutStageBaseRun(
          distanceInKilometers: 1,
          maxHeartRate: 150,
        ),
        WorkoutStageZone2(
          distanceInKilometers: 3,
          maxHeartRate: 165,
        ),
        WorkoutStageBaseRun(
          distanceInKilometers: 3,
          maxHeartRate: 150,
        ),
        WorkoutStageZone3(
          distanceInKilometers: 2,
          maxHeartRate: 180,
        ),
      ],
    ),
    act: (WorkoutCreatorBloc bloc) {
      bloc.add(
        WorkoutCreatorEventWorkoutStagesOrderChanged(
          workoutStages: [
            WorkoutStageBaseRun(
              distanceInKilometers: 3,
              maxHeartRate: 150,
            ),
            WorkoutStageZone3(
              distanceInKilometers: 2,
              maxHeartRate: 180,
            ),
            WorkoutStageBaseRun(
              distanceInKilometers: 1,
              maxHeartRate: 150,
            ),
            WorkoutStageZone2(
              distanceInKilometers: 3,
              maxHeartRate: 165,
            ),
          ],
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        stages: [
          WorkoutStageBaseRun(
            distanceInKilometers: 3,
            maxHeartRate: 150,
          ),
          WorkoutStageZone3(
            distanceInKilometers: 2,
            maxHeartRate: 180,
          ),
          WorkoutStageBaseRun(
            distanceInKilometers: 1,
            maxHeartRate: 150,
          ),
          WorkoutStageZone2(
            distanceInKilometers: 3,
            maxHeartRate: 165,
          ),
        ],
      )
    ],
  );

  blocTest(
    'delete workout stage, '
    'should delete workout stage by its index',
    build: () => createBloc(
      stages: [
        WorkoutStageZone2(
          distanceInKilometers: 5,
          maxHeartRate: 165,
        ),
        WorkoutStageBaseRun(
          distanceInKilometers: 15,
          maxHeartRate: 150,
        ),
      ],
    ),
    act: (WorkoutCreatorBloc bloc) {
      bloc.add(
        const WorkoutCreatorEventDeleteWorkoutStage(index: 0),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        stages: [
          WorkoutStageBaseRun(
            distanceInKilometers: 15,
            maxHeartRate: 150,
          ),
        ],
      ),
    ],
  );
}
