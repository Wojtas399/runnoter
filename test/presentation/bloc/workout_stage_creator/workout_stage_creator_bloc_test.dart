import 'package:bloc_test/bloc_test.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/workout_stage_creator/bloc/workout_stage_creator_bloc.dart';

void main() {
  WorkoutStageCreatorBloc createBloc({
    WorkoutStageCreatorForm? form,
  }) =>
      WorkoutStageCreatorBloc(
        form: form,
      );

  WorkoutStageCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    WorkoutStageCreatorForm? form,
  }) =>
      WorkoutStageCreatorState(
        status: status,
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
        form: createDistanceStageForm(),
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
        form: createDistanceStageForm(),
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
        form: createDistanceStageForm(),
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
        form: createSeriesStageForm(),
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
        form: createSeriesStageForm(),
      ),
    ],
  );

  blocTest(
    'stage type changed, '
    'stretching stage, '
    'should set form as null',
    build: () => createBloc(
      form: createDistanceStageForm(),
    ),
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
    build: () => createBloc(
      form: createDistanceStageForm(),
    ),
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
    build: () => createBloc(
      form: createDistanceStageForm(),
    ),
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
      createState(
        status: const BlocStatusComplete(),
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
      createState(
        status: const BlocStatusComplete(),
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
      createState(
        status: const BlocStatusComplete(),
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
      createState(
        status: const BlocStatusComplete(),
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
      createState(
        status: const BlocStatusComplete(),
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
      createState(
        status: const BlocStatusComplete(),
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
