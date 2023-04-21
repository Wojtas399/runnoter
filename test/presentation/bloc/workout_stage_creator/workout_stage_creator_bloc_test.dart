import 'package:bloc_test/bloc_test.dart';
import 'package:runnoter/presentation/screen/workout_stage_creator/bloc/workout_stage_creator_bloc.dart';

void main() {
  WorkoutStageCreatorBloc createBloc({
    WorkoutStageCreatorForm? form,
  }) =>
      WorkoutStageCreatorBloc(
        form: form,
      );

  WorkoutStageCreatorState createStateInProgress({
    WorkoutStageType? stageType,
    WorkoutStageCreatorForm? form,
  }) =>
      WorkoutStageCreatorStateInProgress(
        stageType: stageType,
        form: form,
      );

  WorkoutStageCreatorDistanceStageForm createDistanceStageForm({
    double? distanceInKm,
    int? maxHeartRate,
  }) =>
      WorkoutStageCreatorDistanceStageForm(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );

  WorkoutStageCreatorSeriesStageForm createSeriesStageForm({
    int? amountOfSeries,
    int? seriesDistanceInMeters,
    int? breakWalkingDistanceInMeters,
    int? breakJoggingDistanceInMeters,
  }) =>
      WorkoutStageCreatorSeriesStageForm(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        breakWalkingDistanceInMeters: breakWalkingDistanceInMeters,
        breakJoggingDistanceInMeters: breakJoggingDistanceInMeters,
      );

  blocTest(
    'stage type changed, '
    'base run stage, '
    'should emit in progress state with form set as distance stage and stage type set as base run',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventStageTypeChanged(
          stageType: WorkoutStageType.baseRun,
        ),
      );
    },
    expect: () => [
      createStateInProgress(
        stageType: WorkoutStageType.baseRun,
        form: createDistanceStageForm(),
      ),
    ],
  );

  blocTest(
    'stage type changed, '
    'zone2 stage, '
    'should emit in progress state with form set as distance stage and stage type set as zone 1',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventStageTypeChanged(
          stageType: WorkoutStageType.zone2,
        ),
      );
    },
    expect: () => [
      createStateInProgress(
        stageType: WorkoutStageType.zone2,
        form: createDistanceStageForm(),
      ),
    ],
  );

  blocTest(
    'stage type changed, '
    'zone3 stage, '
    'should emit in progress state witch form set as distance stage and stage type set as zone 3',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventStageTypeChanged(
          stageType: WorkoutStageType.zone3,
        ),
      );
    },
    expect: () => [
      createStateInProgress(
        stageType: WorkoutStageType.zone3,
        form: createDistanceStageForm(),
      ),
    ],
  );

  blocTest(
    'stage type changed, '
    'hill repeats stage, '
    'should emit in progress state with form set as series stage and stage type set as hill repeats',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventStageTypeChanged(
          stageType: WorkoutStageType.hillRepeats,
        ),
      );
    },
    expect: () => [
      createStateInProgress(
        stageType: WorkoutStageType.hillRepeats,
        form: createSeriesStageForm(),
      ),
    ],
  );

  blocTest(
    'stage type changed, '
    'rhythms stage, '
    'should emit in progress state with form set as series stage and stage type set as rhythms',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventStageTypeChanged(
          stageType: WorkoutStageType.rhythms,
        ),
      );
    },
    expect: () => [
      createStateInProgress(
        stageType: WorkoutStageType.rhythms,
        form: createSeriesStageForm(),
      ),
    ],
  );

  blocTest(
    'stage type changed, '
    'stretching stage, '
    'should emit in progress state with form set as null and stage type set as stretching',
    build: () => createBloc(
      form: createDistanceStageForm(),
    ),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventStageTypeChanged(
          stageType: WorkoutStageType.stretching,
        ),
      );
    },
    expect: () => [
      createStateInProgress(
        stageType: WorkoutStageType.stretching,
        form: null,
      ),
    ],
  );

  blocTest(
    'stage type changed, '
    'strengthening stage, '
    'should emit in progress state with form set as null and stage type set as strengthening',
    build: () => createBloc(
      form: createDistanceStageForm(),
    ),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventStageTypeChanged(
          stageType: WorkoutStageType.strengthening,
        ),
      );
    },
    expect: () => [
      createStateInProgress(
        stageType: WorkoutStageType.strengthening,
        form: null,
      ),
    ],
  );

  blocTest(
    'stage type changed, '
    'foam rolling stage, '
    'should emit in progress state with form set as null and stage type set as foam rolling',
    build: () => createBloc(
      form: createDistanceStageForm(),
    ),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventStageTypeChanged(
          stageType: WorkoutStageType.foamRolling,
        ),
      );
    },
    expect: () => [
      createStateInProgress(
        stageType: WorkoutStageType.foamRolling,
        form: null,
      ),
    ],
  );

  blocTest(
    'distance changed, '
    'distance stage form, '
    'should update distance in form',
    build: () => createBloc(
      form: createDistanceStageForm(
        distanceInKm: 5,
        maxHeartRate: 150,
      ),
    ),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventDistanceChanged(
          distanceInKm: 10.5,
        ),
      );
    },
    expect: () => [
      createStateInProgress(
        form: createDistanceStageForm(
          distanceInKm: 10.5,
          maxHeartRate: 150,
        ),
      ),
    ],
  );

  blocTest(
    'distance changed, '
    'series stage form, '
    'should do nothing',
    build: () => createBloc(
      form: createSeriesStageForm(),
    ),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventDistanceChanged(
          distanceInKm: 10.5,
        ),
      );
    },
    expect: () => [],
  );

  blocTest(
    'distance changed, '
    'form is not set, '
    'should do nothing',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventDistanceChanged(
          distanceInKm: 10.5,
        ),
      );
    },
    expect: () => [],
  );

  blocTest(
    'max heart rate changed, '
    'distance stage form, '
    'should update max heart rate in form',
    build: () => createBloc(
      form: createDistanceStageForm(
        distanceInKm: 5,
        maxHeartRate: 150,
      ),
    ),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventMaxHeartRateChanged(
          maxHeartRate: 140,
        ),
      );
    },
    expect: () => [
      createStateInProgress(
        form: createDistanceStageForm(
          distanceInKm: 5,
          maxHeartRate: 140,
        ),
      ),
    ],
  );

  blocTest(
    'max heart rate changed, '
    'series stage form, '
    'should do nothing',
    build: () => createBloc(
      form: createSeriesStageForm(),
    ),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventMaxHeartRateChanged(
          maxHeartRate: 140,
        ),
      );
    },
    expect: () => [],
  );

  blocTest(
    'max heart rate changed, '
    'form is not set, '
    'should do nothing',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventMaxHeartRateChanged(
          maxHeartRate: 140,
        ),
      );
    },
    expect: () => [],
  );

  blocTest(
    'amount of series changed, '
    'series stage form, '
    'should update amount of series in form',
    build: () => createBloc(
      form: createSeriesStageForm(
        amountOfSeries: 5,
        seriesDistanceInMeters: 100,
        breakWalkingDistanceInMeters: 20,
        breakJoggingDistanceInMeters: 80,
      ),
    ),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventAmountOfSeriesChanged(
          amountOfSeries: 10,
        ),
      );
    },
    expect: () => [
      createStateInProgress(
        form: createSeriesStageForm(
          amountOfSeries: 10,
          seriesDistanceInMeters: 100,
          breakWalkingDistanceInMeters: 20,
          breakJoggingDistanceInMeters: 80,
        ),
      ),
    ],
  );

  blocTest(
    'amount of series changed, '
    'distance stage form, '
    'should do nothing',
    build: () => createBloc(
      form: createDistanceStageForm(),
    ),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventAmountOfSeriesChanged(
          amountOfSeries: 10,
        ),
      );
    },
    expect: () => [],
  );

  blocTest(
    'amount of series changed, '
    'form is not set, '
    'should do nothing',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventAmountOfSeriesChanged(
          amountOfSeries: 10,
        ),
      );
    },
    expect: () => [],
  );

  blocTest(
    'series distance changed, '
    'series stage form, '
    'should update series distance in form',
    build: () => createBloc(
      form: createSeriesStageForm(
        amountOfSeries: 5,
        seriesDistanceInMeters: 50,
        breakWalkingDistanceInMeters: 20,
        breakJoggingDistanceInMeters: 80,
      ),
    ),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventSeriesDistanceChanged(
          seriesDistanceInMeters: 100,
        ),
      );
    },
    expect: () => [
      createStateInProgress(
        form: createSeriesStageForm(
          amountOfSeries: 5,
          seriesDistanceInMeters: 100,
          breakWalkingDistanceInMeters: 20,
          breakJoggingDistanceInMeters: 80,
        ),
      ),
    ],
  );

  blocTest(
    'series distance changed, '
    'distance stage form, '
    'should do nothing',
    build: () => createBloc(
      form: createDistanceStageForm(),
    ),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventSeriesDistanceChanged(
          seriesDistanceInMeters: 100,
        ),
      );
    },
    expect: () => [],
  );

  blocTest(
    'series distance changed, '
    'form is not set, '
    'should do nothing',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventSeriesDistanceChanged(
          seriesDistanceInMeters: 100,
        ),
      );
    },
    expect: () => [],
  );

  blocTest(
    'walking distance changed, '
    'series stage form, '
    'should update walking distance in form',
    build: () => createBloc(
      form: createSeriesStageForm(
        amountOfSeries: 5,
        seriesDistanceInMeters: 100,
        breakWalkingDistanceInMeters: 20,
        breakJoggingDistanceInMeters: 80,
      ),
    ),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventWalkingDistanceChanged(
          walkingDistanceInMeters: 100,
        ),
      );
    },
    expect: () => [
      createStateInProgress(
        form: createSeriesStageForm(
          amountOfSeries: 5,
          seriesDistanceInMeters: 100,
          breakWalkingDistanceInMeters: 100,
          breakJoggingDistanceInMeters: 80,
        ),
      ),
    ],
  );

  blocTest(
    'walking distance changed, '
    'distance stage form, '
    'should do nothing',
    build: () => createBloc(
      form: createDistanceStageForm(),
    ),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventWalkingDistanceChanged(
          walkingDistanceInMeters: 100,
        ),
      );
    },
    expect: () => [],
  );

  blocTest(
    'walking distance changed, '
    'form is not set, '
    'should do nothing',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventWalkingDistanceChanged(
          walkingDistanceInMeters: 100,
        ),
      );
    },
    expect: () => [],
  );

  blocTest(
    'jogging distance changed, '
    'series stage form, '
    'should update jogging distance in form',
    build: () => createBloc(
      form: createSeriesStageForm(
        amountOfSeries: 5,
        seriesDistanceInMeters: 100,
        breakWalkingDistanceInMeters: 20,
        breakJoggingDistanceInMeters: 80,
      ),
    ),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventJoggingDistanceChanged(
          joggingDistanceInMeters: 100,
        ),
      );
    },
    expect: () => [
      createStateInProgress(
        form: createSeriesStageForm(
          amountOfSeries: 5,
          seriesDistanceInMeters: 100,
          breakWalkingDistanceInMeters: 20,
          breakJoggingDistanceInMeters: 100,
        ),
      ),
    ],
  );

  blocTest(
    'jogging distance changed, '
    'distance stage form, '
    'should do nothing',
    build: () => createBloc(
      form: createDistanceStageForm(),
    ),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventJoggingDistanceChanged(
          joggingDistanceInMeters: 100,
        ),
      );
    },
    expect: () => [],
  );

  blocTest(
    'jogging distance changed, '
    'form is not set, '
    'should do nothing',
    build: () => createBloc(),
    act: (WorkoutStageCreatorBloc bloc) {
      bloc.add(
        const WorkoutStageCreatorEventJoggingDistanceChanged(
          joggingDistanceInMeters: 100,
        ),
      );
    },
    expect: () => [],
  );
}
