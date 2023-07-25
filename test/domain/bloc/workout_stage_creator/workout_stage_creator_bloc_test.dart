import 'package:bloc_test/bloc_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/workout_stage_creator/workout_stage_creator_bloc.dart';
import 'package:runnoter/domain/entity/workout_stage.dart';

void main() {
  WorkoutStageCreatorBloc createBloc({
    WorkoutStage? originalStage,
    WorkoutStageType? stageType,
    WorkoutStageCreatorDistanceForm distanceForm =
        const WorkoutStageCreatorDistanceForm(),
    WorkoutStageCreatorSeriesForm seriesForm =
        const WorkoutStageCreatorSeriesForm(),
  }) =>
      WorkoutStageCreatorBloc(
        originalStage: originalStage,
        state: WorkoutStageCreatorState(
          status: const BlocStatusInitial(),
          stageType: stageType,
          distanceForm: distanceForm,
          seriesForm: seriesForm,
        ),
      );

  WorkoutStageCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    WorkoutStageType? originalStageType,
    WorkoutStageType? stageType,
    WorkoutStageCreatorDistanceForm distanceForm =
        const WorkoutStageCreatorDistanceForm(),
    WorkoutStageCreatorSeriesForm seriesForm =
        const WorkoutStageCreatorSeriesForm(),
    WorkoutStage? stageToSubmit,
  }) =>
      WorkoutStageCreatorState(
        status: status,
        originalStageType: originalStageType,
        stageType: stageType,
        distanceForm: distanceForm,
        seriesForm: seriesForm,
        stageToSubmit: stageToSubmit,
      );

  WorkoutStageCreatorDistanceForm createDistanceForm({
    DistanceWorkoutStage? originalStage,
    double? distanceInKm,
    int? maxHeartRate,
  }) =>
      WorkoutStageCreatorDistanceForm(
        originalStage: originalStage,
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );

  WorkoutStageCreatorSeriesForm createSeriesForm({
    SeriesWorkoutStage? originalStage,
    int? amountOfSeries,
    int? seriesDistanceInMeters,
    int? walkingDistanceInMeters,
    int? joggingDistanceInMeters,
  }) =>
      WorkoutStageCreatorSeriesForm(
        originalStage: originalStage,
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters,
        joggingDistanceInMeters: joggingDistanceInMeters,
      );

  blocTest(
    'initialize, '
    'original stage is null, '
    'should do nothing',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const WorkoutStageCreatorEventInitialize()),
    expect: () => [],
  );

  blocTest(
    'initialize, '
    'original stage is a distance stage, '
    'should set original stage type, stage type and distance form',
    build: () => createBloc(
      originalStage: const WorkoutStageZone2(
        distanceInKm: 5,
        maxHeartRate: 165,
      ),
    ),
    act: (bloc) => bloc.add(const WorkoutStageCreatorEventInitialize()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        originalStageType: WorkoutStageType.zone2,
        stageType: WorkoutStageType.zone2,
        distanceForm: const WorkoutStageCreatorDistanceForm(
          originalStage: WorkoutStageZone2(
            distanceInKm: 5,
            maxHeartRate: 165,
          ),
          distanceInKm: 5,
          maxHeartRate: 165,
        ),
      ),
    ],
  );

  blocTest(
    'initialize, '
    'original stage is a series stage, '
    'should set original stage type, stage type and series form',
    build: () => createBloc(
      originalStage: const WorkoutStageRhythms(
        amountOfSeries: 10,
        seriesDistanceInMeters: 100,
        walkingDistanceInMeters: 20,
        joggingDistanceInMeters: 80,
      ),
    ),
    act: (bloc) => bloc.add(const WorkoutStageCreatorEventInitialize()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        originalStageType: WorkoutStageType.rhythms,
        stageType: WorkoutStageType.rhythms,
        seriesForm: const WorkoutStageCreatorSeriesForm(
          originalStage: WorkoutStageRhythms(
            amountOfSeries: 10,
            seriesDistanceInMeters: 100,
            walkingDistanceInMeters: 20,
            joggingDistanceInMeters: 80,
          ),
          amountOfSeries: 10,
          seriesDistanceInMeters: 100,
          walkingDistanceInMeters: 20,
          joggingDistanceInMeters: 80,
        ),
      ),
    ],
  );

  blocTest(
    'stage type changed, '
    'should update stage type in state',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const WorkoutStageCreatorEventStageTypeChanged(
      stageType: WorkoutStageType.zone2,
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        stageType: WorkoutStageType.zone2,
      ),
    ],
  );

  blocTest(
    'distance changed, '
    'should update distance in distance form',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const WorkoutStageCreatorEventDistanceChanged(
      distanceInKm: 10.5,
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        distanceForm: createDistanceForm(
          distanceInKm: 10.5,
        ),
      ),
    ],
  );

  blocTest(
    'max heart rate changed, '
    'should update max heart rate in distance form',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const WorkoutStageCreatorEventMaxHeartRateChanged(
      maxHeartRate: 140,
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        distanceForm: createDistanceForm(
          maxHeartRate: 140,
        ),
      ),
    ],
  );

  blocTest(
    'amount of series changed, '
    'should update amount of series in series form',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const WorkoutStageCreatorEventAmountOfSeriesChanged(
      amountOfSeries: 10,
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        seriesForm: createSeriesForm(
          amountOfSeries: 10,
        ),
      ),
    ],
  );

  blocTest(
    'series distance changed, '
    'should update series distance in series form',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const WorkoutStageCreatorEventSeriesDistanceChanged(
      seriesDistanceInMeters: 100,
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        seriesForm: createSeriesForm(
          seriesDistanceInMeters: 100,
        ),
      ),
    ],
  );

  blocTest(
    'walking distance changed, '
    'should update walking distance in series form',
    build: () => createBloc(),
    act: (bloc) => bloc.add(
      const WorkoutStageCreatorEventWalkingDistanceChanged(
        walkingDistanceInMeters: 100,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        seriesForm: createSeriesForm(
          walkingDistanceInMeters: 100,
        ),
      ),
    ],
  );

  blocTest(
    'jogging distance changed, '
    'should update jogging distance in series form',
    build: () => createBloc(),
    act: (bloc) => bloc.add(
      const WorkoutStageCreatorEventJoggingDistanceChanged(
        joggingDistanceInMeters: 100,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        seriesForm: createSeriesForm(
          joggingDistanceInMeters: 100,
        ),
      ),
    ],
  );

  blocTest(
    'submit, '
    'stage type is null, '
    'should do nothing',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const WorkoutStageCreatorEventSubmit()),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'cardio, '
    'should set stage to submit as workout stage cardio',
    build: () => createBloc(
      stageType: WorkoutStageType.cardio,
      distanceForm: createDistanceForm(
        distanceInKm: 10.5,
        maxHeartRate: 150,
      ),
    ),
    act: (bloc) => bloc.add(const WorkoutStageCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        stageType: WorkoutStageType.cardio,
        distanceForm: createDistanceForm(
          distanceInKm: 10.5,
          maxHeartRate: 150,
        ),
        stageToSubmit: const WorkoutStageCardio(
          distanceInKm: 10.5,
          maxHeartRate: 150,
        ),
      ),
    ],
  );

  blocTest(
    'submit, '
    'zone 2, '
    'should set stage to submit as workout stage zone 2',
    build: () => createBloc(
      stageType: WorkoutStageType.zone2,
      distanceForm: createDistanceForm(
        distanceInKm: 10.5,
        maxHeartRate: 150,
      ),
    ),
    act: (bloc) => bloc.add(const WorkoutStageCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        stageType: WorkoutStageType.zone2,
        distanceForm: createDistanceForm(
          distanceInKm: 10.5,
          maxHeartRate: 150,
        ),
        stageToSubmit: const WorkoutStageZone2(
          distanceInKm: 10.5,
          maxHeartRate: 150,
        ),
      ),
    ],
  );

  blocTest(
    'submit, '
    'zone 3, '
    'should set stage to submit as workout stage zone 3',
    build: () => createBloc(
      stageType: WorkoutStageType.zone3,
      distanceForm: createDistanceForm(
        distanceInKm: 10.5,
        maxHeartRate: 150,
      ),
    ),
    act: (bloc) => bloc.add(const WorkoutStageCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        stageType: WorkoutStageType.zone3,
        distanceForm: createDistanceForm(
          distanceInKm: 10.5,
          maxHeartRate: 150,
        ),
        stageToSubmit: const WorkoutStageZone3(
          distanceInKm: 10.5,
          maxHeartRate: 150,
        ),
      ),
    ],
  );

  blocTest(
    'submit, '
    'hill repeats, '
    'should set stage to submit as workout stage hill repeats',
    build: () => createBloc(
      stageType: WorkoutStageType.hillRepeats,
      seriesForm: createSeriesForm(
        amountOfSeries: 10,
        seriesDistanceInMeters: 100,
        walkingDistanceInMeters: 20,
        joggingDistanceInMeters: 80,
      ),
    ),
    act: (bloc) => bloc.add(const WorkoutStageCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        stageType: WorkoutStageType.hillRepeats,
        seriesForm: createSeriesForm(
          amountOfSeries: 10,
          seriesDistanceInMeters: 100,
          walkingDistanceInMeters: 20,
          joggingDistanceInMeters: 80,
        ),
        stageToSubmit: const WorkoutStageHillRepeats(
          amountOfSeries: 10,
          seriesDistanceInMeters: 100,
          walkingDistanceInMeters: 20,
          joggingDistanceInMeters: 80,
        ),
      ),
    ],
  );

  blocTest(
    'submit, '
    'rhythms, '
    'should set stage to submit as workout stage rhythms',
    build: () => createBloc(
      stageType: WorkoutStageType.rhythms,
      seriesForm: createSeriesForm(
        amountOfSeries: 10,
        seriesDistanceInMeters: 100,
        walkingDistanceInMeters: 20,
        joggingDistanceInMeters: 80,
      ),
    ),
    act: (bloc) => bloc.add(const WorkoutStageCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        stageType: WorkoutStageType.rhythms,
        seriesForm: createSeriesForm(
          amountOfSeries: 10,
          seriesDistanceInMeters: 100,
          walkingDistanceInMeters: 20,
          joggingDistanceInMeters: 80,
        ),
        stageToSubmit: const WorkoutStageRhythms(
          amountOfSeries: 10,
          seriesDistanceInMeters: 100,
          walkingDistanceInMeters: 20,
          joggingDistanceInMeters: 80,
        ),
      ),
    ],
  );
}
