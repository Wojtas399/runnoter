import 'package:bloc_test/bloc_test.dart';
import 'package:runnoter/data/additional_model/workout_stage.dart';
import 'package:runnoter/ui/feature/dialog/workout_stage_creator/cubit/workout_stage_creator_cubit.dart';

void main() {
  blocTest(
    'initialize, '
    'original stage is null, '
    'should do nothing',
    build: () => WorkoutStageCreatorCubit(),
    act: (cubit) => cubit.initialize(),
    expect: () => [],
  );

  blocTest(
    'initialize, '
    'original stage is a distance stage, '
    'should set original stage type, stage type and distance form',
    build: () => WorkoutStageCreatorCubit(
      originalStage: const WorkoutStageZone2(
        distanceInKm: 5,
        maxHeartRate: 165,
      ),
    ),
    act: (cubit) => cubit.initialize(),
    expect: () => [
      const WorkoutStageCreatorState(
        originalStageType: WorkoutStageType.zone2,
        stageType: WorkoutStageType.zone2,
        distanceForm: WorkoutStageCreatorDistanceForm(
          originalStage: WorkoutStageZone2(distanceInKm: 5, maxHeartRate: 165),
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
    build: () => WorkoutStageCreatorCubit(
      originalStage: const WorkoutStageRhythms(
        amountOfSeries: 10,
        seriesDistanceInMeters: 100,
        walkingDistanceInMeters: 20,
        joggingDistanceInMeters: 80,
      ),
    ),
    act: (cubit) => cubit.initialize(),
    expect: () => [
      const WorkoutStageCreatorState(
        originalStageType: WorkoutStageType.rhythms,
        stageType: WorkoutStageType.rhythms,
        seriesForm: WorkoutStageCreatorSeriesForm(
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
    build: () => WorkoutStageCreatorCubit(),
    act: (cubit) => cubit.stageTypeChanged(WorkoutStageType.zone2),
    expect: () => [
      const WorkoutStageCreatorState(stageType: WorkoutStageType.zone2),
    ],
  );

  blocTest(
    'distance changed, '
    'should update distance in distance form',
    build: () => WorkoutStageCreatorCubit(),
    act: (cubit) => cubit.distanceChanged(10.5),
    expect: () => [
      const WorkoutStageCreatorState(
        distanceForm: WorkoutStageCreatorDistanceForm(distanceInKm: 10.5),
      ),
    ],
  );

  blocTest(
    'max heart rate changed, '
    'should update max heart rate in distance form',
    build: () => WorkoutStageCreatorCubit(),
    act: (cubit) => cubit.maxHeartRateChanged(140),
    expect: () => [
      const WorkoutStageCreatorState(
        distanceForm: WorkoutStageCreatorDistanceForm(maxHeartRate: 140),
      ),
    ],
  );

  blocTest(
    'amount of series changed, '
    'should update amount of series in series form',
    build: () => WorkoutStageCreatorCubit(),
    act: (cubit) => cubit.amountOfSeriesChanged(10),
    expect: () => [
      const WorkoutStageCreatorState(
        seriesForm: WorkoutStageCreatorSeriesForm(amountOfSeries: 10),
      ),
    ],
  );

  blocTest(
    'series distance changed, '
    'should update series distance in series form',
    build: () => WorkoutStageCreatorCubit(),
    act: (cubit) => cubit.seriesDistanceChanged(100),
    expect: () => [
      const WorkoutStageCreatorState(
        seriesForm: WorkoutStageCreatorSeriesForm(seriesDistanceInMeters: 100),
      ),
    ],
  );

  blocTest(
    'walking distance changed, '
    'should update walking distance in series form',
    build: () => WorkoutStageCreatorCubit(),
    act: (cubit) => cubit.walkingDistanceChanged(100),
    expect: () => [
      const WorkoutStageCreatorState(
        seriesForm: WorkoutStageCreatorSeriesForm(walkingDistanceInMeters: 100),
      ),
    ],
  );

  blocTest(
    'jogging distance changed, '
    'should update jogging distance in series form',
    build: () => WorkoutStageCreatorCubit(),
    act: (cubit) => cubit.joggingDistanceChanged(100),
    expect: () => [
      const WorkoutStageCreatorState(
        seriesForm: WorkoutStageCreatorSeriesForm(joggingDistanceInMeters: 100),
      ),
    ],
  );

  blocTest(
    'submit, '
    'stage type is null, '
    'should do nothing',
    build: () => WorkoutStageCreatorCubit(),
    act: (cubit) => cubit.submit(),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'cardio, '
    'should set stage to add as workout stage cardio',
    build: () => WorkoutStageCreatorCubit(
      initialState: const WorkoutStageCreatorState(
        stageType: WorkoutStageType.cardio,
        distanceForm: WorkoutStageCreatorDistanceForm(
          distanceInKm: 10.5,
          maxHeartRate: 150,
        ),
      ),
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [
      const WorkoutStageCreatorState(
        stageType: WorkoutStageType.cardio,
        distanceForm: WorkoutStageCreatorDistanceForm(
          distanceInKm: 10.5,
          maxHeartRate: 150,
        ),
        stageToAdd: WorkoutStageCardio(distanceInKm: 10.5, maxHeartRate: 150),
      ),
    ],
  );

  blocTest(
    'submit, '
    'zone 2, '
    'should set stage to add as workout stage zone 2',
    build: () => WorkoutStageCreatorCubit(
      initialState: const WorkoutStageCreatorState(
        stageType: WorkoutStageType.zone2,
        distanceForm: WorkoutStageCreatorDistanceForm(
          distanceInKm: 10.5,
          maxHeartRate: 150,
        ),
      ),
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [
      const WorkoutStageCreatorState(
        stageType: WorkoutStageType.zone2,
        distanceForm: WorkoutStageCreatorDistanceForm(
          distanceInKm: 10.5,
          maxHeartRate: 150,
        ),
        stageToAdd: WorkoutStageZone2(distanceInKm: 10.5, maxHeartRate: 150),
      ),
    ],
  );

  blocTest(
    'submit, '
    'zone 3, '
    'should set stage to add as workout stage zone 3',
    build: () => WorkoutStageCreatorCubit(
        initialState: const WorkoutStageCreatorState(
      stageType: WorkoutStageType.zone3,
      distanceForm: WorkoutStageCreatorDistanceForm(
        distanceInKm: 10.5,
        maxHeartRate: 150,
      ),
    )),
    act: (cubit) => cubit.submit(),
    expect: () => [
      const WorkoutStageCreatorState(
        stageType: WorkoutStageType.zone3,
        distanceForm: WorkoutStageCreatorDistanceForm(
          distanceInKm: 10.5,
          maxHeartRate: 150,
        ),
        stageToAdd: WorkoutStageZone3(distanceInKm: 10.5, maxHeartRate: 150),
      ),
    ],
  );

  blocTest(
    'submit, '
    'hill repeats, '
    'should set stage to submit as workout stage hill repeats',
    build: () => WorkoutStageCreatorCubit(
      initialState: const WorkoutStageCreatorState(
        stageType: WorkoutStageType.hillRepeats,
        seriesForm: WorkoutStageCreatorSeriesForm(
          amountOfSeries: 10,
          seriesDistanceInMeters: 100,
          walkingDistanceInMeters: 20,
          joggingDistanceInMeters: 80,
        ),
      ),
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [
      const WorkoutStageCreatorState(
        stageType: WorkoutStageType.hillRepeats,
        seriesForm: WorkoutStageCreatorSeriesForm(
          amountOfSeries: 10,
          seriesDistanceInMeters: 100,
          walkingDistanceInMeters: 20,
          joggingDistanceInMeters: 80,
        ),
        stageToAdd: WorkoutStageHillRepeats(
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
    build: () => WorkoutStageCreatorCubit(
      initialState: const WorkoutStageCreatorState(
        stageType: WorkoutStageType.rhythms,
        seriesForm: WorkoutStageCreatorSeriesForm(
          amountOfSeries: 10,
          seriesDistanceInMeters: 100,
          walkingDistanceInMeters: 20,
          joggingDistanceInMeters: 80,
        ),
      ),
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [
      const WorkoutStageCreatorState(
        stageType: WorkoutStageType.rhythms,
        seriesForm: WorkoutStageCreatorSeriesForm(
          amountOfSeries: 10,
          seriesDistanceInMeters: 100,
          walkingDistanceInMeters: 20,
          joggingDistanceInMeters: 80,
        ),
        stageToAdd: WorkoutStageRhythms(
          amountOfSeries: 10,
          seriesDistanceInMeters: 100,
          walkingDistanceInMeters: 20,
          joggingDistanceInMeters: 80,
        ),
      ),
    ],
  );
}
