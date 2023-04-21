import 'package:bloc_test/bloc_test.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/workout_stage_creator/bloc/workout_stage_creator_bloc.dart';
import 'package:runnoter/presentation/screen/workout_stage_creator/bloc/workout_stage_creator_distance_stage_state.dart';
import 'package:runnoter/presentation/screen/workout_stage_creator/bloc/workout_stage_creator_empty_state.dart';
import 'package:runnoter/presentation/screen/workout_stage_creator/bloc/workout_stage_creator_event.dart';
import 'package:runnoter/presentation/screen/workout_stage_creator/bloc/workout_stage_creator_series_stage_state.dart';
import 'package:runnoter/presentation/screen/workout_stage_creator/bloc/workout_stage_creator_state.dart';

void main() {
  WorkoutStageCreatorBloc createBloc() => WorkoutStageCreatorBloc();

  blocTest(
    'stage type changed, '
    'base run stage, '
    'should set state as distance state',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventStageTypeChanged(
          stage: WorkoutStage.baseRun,
        ),
      );
    },
    expect: () => [
      const WorkoutStageCreatorDistanceStageState(
        status: BlocStatusComplete(),
        distanceInKm: null,
        maxHeartRate: null,
      ),
    ],
  );

  blocTest(
    'stage type changed, '
    'zone2 stage, '
    'should set state as distance state',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventStageTypeChanged(
          stage: WorkoutStage.zone2,
        ),
      );
    },
    expect: () => [
      const WorkoutStageCreatorDistanceStageState(
        status: BlocStatusComplete(),
        distanceInKm: null,
        maxHeartRate: null,
      ),
    ],
  );

  blocTest(
    'stage type changed, '
    'zone3 stage, '
    'should set state as distance state',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventStageTypeChanged(
          stage: WorkoutStage.zone3,
        ),
      );
    },
    expect: () => [
      const WorkoutStageCreatorDistanceStageState(
        status: BlocStatusComplete(),
        distanceInKm: null,
        maxHeartRate: null,
      ),
    ],
  );

  blocTest(
    'stage type changed, '
    'hill repeats stage, '
    'should set state as series state',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventStageTypeChanged(
          stage: WorkoutStage.hillRepeats,
        ),
      );
    },
    expect: () => [
      const WorkoutStageCreatorSeriesStageState(
        status: BlocStatusComplete(),
        amountOfSeries: null,
        seriesDistanceInMeters: null,
        breakWalkingDistanceInMeters: null,
        breakJoggingDistanceInMeters: null,
      ),
    ],
  );

  blocTest(
    'stage type changed, '
    'rhythms stage, '
    'should set state as series state',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventStageTypeChanged(
          stage: WorkoutStage.rhythms,
        ),
      );
    },
    expect: () => [
      const WorkoutStageCreatorSeriesStageState(
        status: BlocStatusComplete(),
        amountOfSeries: null,
        seriesDistanceInMeters: null,
        breakWalkingDistanceInMeters: null,
        breakJoggingDistanceInMeters: null,
      ),
    ],
  );

  blocTest(
    'stage type changed, '
    'stretching stage, '
    'should set state as empty state',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventStageTypeChanged(
          stage: WorkoutStage.stretching,
        ),
      );
    },
    expect: () => [
      const WorkoutStageCreatorEmptyState(
        status: BlocStatusComplete(),
      ),
    ],
  );

  blocTest(
    'stage type changed, '
    'strengthening stage, '
    'should set state as empty state',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventStageTypeChanged(
          stage: WorkoutStage.strengthening,
        ),
      );
    },
    expect: () => [
      const WorkoutStageCreatorEmptyState(
        status: BlocStatusComplete(),
      ),
    ],
  );

  blocTest(
    'stage type changed, '
    'foam rolling stage, '
    'should set state as empty state',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventStageTypeChanged(
          stage: WorkoutStage.foamRolling,
        ),
      );
    },
    expect: () => [
      const WorkoutStageCreatorEmptyState(
        status: BlocStatusComplete(),
      ),
    ],
  );
}
