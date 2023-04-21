import 'package:bloc_test/bloc_test.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/workout_stage_creator/bloc/workout_stage_creator_bloc.dart';

void main() {
  WorkoutStageCreatorBloc createBloc() => WorkoutStageCreatorBloc();

  WorkoutStageCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    WorkoutStageCreatorForm? form,
  }) =>
      WorkoutStageCreatorState(
        status: status,
        form: form,
      );

  blocTest(
    'stage type changed, '
    'base run stage, '
    'should set form as distance stage form',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventStageTypeChanged(
          stage: WorkoutStage.baseRun,
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        form: const WorkoutStageCreatorDistanceStageForm(
          distanceInKm: null,
          maxHeartRate: null,
        ),
      ),
    ],
  );

  blocTest(
    'stage type changed, '
    'zone2 stage, '
    'should set form as distance stage form',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventStageTypeChanged(
          stage: WorkoutStage.zone2,
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        form: const WorkoutStageCreatorDistanceStageForm(
          distanceInKm: null,
          maxHeartRate: null,
        ),
      ),
    ],
  );

  blocTest(
    'stage type changed, '
    'zone3 stage, '
    'should set form as distance stage form',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventStageTypeChanged(
          stage: WorkoutStage.zone3,
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        form: const WorkoutStageCreatorDistanceStageForm(
          distanceInKm: null,
          maxHeartRate: null,
        ),
      ),
    ],
  );

  blocTest(
    'stage type changed, '
    'hill repeats stage, '
    'should set form as series stage form',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventStageTypeChanged(
          stage: WorkoutStage.hillRepeats,
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        form: const WorkoutStageCreatorSeriesStageForm(
          amountOfSeries: null,
          seriesDistanceInMeters: null,
          breakWalkingDistanceInMeters: null,
          breakJoggingDistanceInMeters: null,
        ),
      ),
    ],
  );

  blocTest(
    'stage type changed, '
    'rhythms stage, '
    'should set form as series stage form',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventStageTypeChanged(
          stage: WorkoutStage.rhythms,
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        form: const WorkoutStageCreatorSeriesStageForm(
          amountOfSeries: null,
          seriesDistanceInMeters: null,
          breakWalkingDistanceInMeters: null,
          breakJoggingDistanceInMeters: null,
        ),
      ),
    ],
  );

  blocTest(
    'stage type changed, '
    'stretching stage, '
    'should set form as null',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventStageTypeChanged(
          stage: WorkoutStage.stretching,
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        form: null,
      ),
    ],
  );

  blocTest(
    'stage type changed, '
    'strengthening stage, '
    'should set form as null',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventStageTypeChanged(
          stage: WorkoutStage.strengthening,
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        form: null,
      ),
    ],
  );

  blocTest(
    'stage type changed, '
    'foam rolling stage, '
    'should set form as null',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventStageTypeChanged(
          stage: WorkoutStage.foamRolling,
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        form: null,
      ),
    ],
  );
}
