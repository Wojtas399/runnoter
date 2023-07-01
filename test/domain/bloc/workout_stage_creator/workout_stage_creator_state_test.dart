import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/workout_stage_creator/workout_stage_creator_bloc.dart';
import 'package:runnoter/domain/entity/workout_stage.dart';

void main() {
  late WorkoutStageCreatorState state;

  WorkoutStageCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    WorkoutStageType? stageType,
    WorkoutStageCreatorDistanceForm distanceForm =
        const WorkoutStageCreatorDistanceForm(),
    WorkoutStageCreatorSeriesForm seriesForm =
        const WorkoutStageCreatorSeriesForm(),
    WorkoutStage? stageToSubmit,
  }) =>
      WorkoutStageCreatorState(
        status: status,
        stageType: stageType,
        distanceForm: distanceForm,
        seriesForm: seriesForm,
        stageToSubmit: stageToSubmit,
      );

  setUp(
    () => state = createState(),
  );

  test(
    'is submit button disabled, '
    'stage type is null, '
    'should be true',
    () {
      final state = createState();

      expect(state.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'distance stage, '
    'distance form data are invalid, '
    'should be true',
    () {
      const WorkoutStageType stageType = WorkoutStageType.cardio;
      const distanceForm = WorkoutStageCreatorDistanceForm(
        distanceInKm: 0,
        maxHeartRate: 140,
      );

      final state = createState(
        stageType: stageType,
        distanceForm: distanceForm,
      );

      expect(state.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'distance stage, '
    'distance form data are valid, '
    'should be false',
    () {
      const WorkoutStageType stageType = WorkoutStageType.cardio;
      const distanceForm = WorkoutStageCreatorDistanceForm(
        distanceInKm: 10.5,
        maxHeartRate: 140,
      );

      final state = createState(
        stageType: stageType,
        distanceForm: distanceForm,
      );

      expect(state.isSubmitButtonDisabled, false);
    },
  );

  test(
    'is submit button disabled, '
    'series stage, '
    'series form data are invalid, '
    'should be true',
    () {
      const WorkoutStageType stageType = WorkoutStageType.hillRepeats;
      const seriesForm = WorkoutStageCreatorSeriesForm(
        amountOfSeries: 0,
        seriesDistanceInMeters: 100,
        walkingDistanceInMeters: 20,
        joggingDistanceInMeters: 80,
      );

      final state = createState(
        stageType: stageType,
        seriesForm: seriesForm,
      );

      expect(state.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'series stage, '
    'series form data are valid, '
    'should be false',
    () {
      const WorkoutStageType stageType = WorkoutStageType.hillRepeats;
      const seriesForm = WorkoutStageCreatorSeriesForm(
        amountOfSeries: 10,
        seriesDistanceInMeters: 100,
        walkingDistanceInMeters: 20,
        joggingDistanceInMeters: 80,
      );

      final state = createState(
        stageType: stageType,
        seriesForm: seriesForm,
      );

      expect(state.isSubmitButtonDisabled, false);
    },
  );

  test(
    'is distance stage, '
    'stage type is set as cardio, '
    'should be true',
    () {
      state = state.copyWith(stageType: WorkoutStageType.cardio);

      expect(state.isDistanceStage, true);
    },
  );

  test(
    'is distance stage, '
    'stage type is set as zone2, '
    'should be true',
    () {
      state = state.copyWith(stageType: WorkoutStageType.zone2);

      expect(state.isDistanceStage, true);
    },
  );

  test(
    'is distance stage, '
    'stage type is set as zone3, '
    'should be true',
    () {
      state = state.copyWith(stageType: WorkoutStageType.zone3);

      expect(state.isDistanceStage, true);
    },
  );

  test(
    'is distance stage, '
    'stage type is set as hill repeats, '
    'should be false',
    () {
      state = state.copyWith(stageType: WorkoutStageType.hillRepeats);

      expect(state.isDistanceStage, false);
    },
  );

  test(
    'is distance stage, '
    'stage type is set as rhythms, '
    'should be false',
    () {
      state = state.copyWith(stageType: WorkoutStageType.rhythms);

      expect(state.isDistanceStage, false);
    },
  );

  test(
    'is series stage, '
    'stage type is set as cardio, '
    'should be false',
    () {
      state = state.copyWith(stageType: WorkoutStageType.cardio);

      expect(state.isSeriesStage, false);
    },
  );

  test(
    'is series stage, '
    'stage type is set as zone2, '
    'should be false',
    () {
      state = state.copyWith(stageType: WorkoutStageType.zone2);

      expect(state.isSeriesStage, false);
    },
  );

  test(
    'is series stage, '
    'stage type is set as zone3, '
    'should be false',
    () {
      state = state.copyWith(stageType: WorkoutStageType.zone3);

      expect(state.isSeriesStage, false);
    },
  );

  test(
    'is series stage, '
    'stage type is set as hill repeats, '
    'should be true',
    () {
      state = state.copyWith(stageType: WorkoutStageType.hillRepeats);

      expect(state.isSeriesStage, true);
    },
  );

  test(
    'is series stage, '
    'stage type is set as rhythms, '
    'should be true',
    () {
      state = state.copyWith(stageType: WorkoutStageType.rhythms);

      expect(state.isSeriesStage, true);
    },
  );

  test(
    'copy with status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusComplete());
    },
  );

  test(
    'copy with stage type',
    () {
      const WorkoutStageType expectedStageType = WorkoutStageType.hillRepeats;

      state = state.copyWith(stageType: expectedStageType);
      final state2 = state.copyWith();

      expect(state.stageType, expectedStageType);
      expect(state2.stageType, expectedStageType);
    },
  );

  test(
    'copy with distance form',
    () {
      const expectedDistanceForm = WorkoutStageCreatorDistanceForm(
        originalStage: WorkoutStageZone2(
          distanceInKilometers: 5,
          maxHeartRate: 165,
        ),
        distanceInKm: 6.0,
        maxHeartRate: 165,
      );

      state = state.copyWith(distanceForm: expectedDistanceForm);
      final state2 = state.copyWith();

      expect(state.distanceForm, expectedDistanceForm);
      expect(state2.distanceForm, expectedDistanceForm);
    },
  );

  test(
    'copy with series form',
    () {
      const expectedSeriesForm = WorkoutStageCreatorSeriesForm(
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
      );

      state = state.copyWith(seriesForm: expectedSeriesForm);
      final state2 = state.copyWith();

      expect(state.seriesForm, expectedSeriesForm);
      expect(state2.seriesForm, expectedSeriesForm);
    },
  );

  test(
    'copy with stage to submit',
    () {
      const WorkoutStage expectedStageToSubmit = WorkoutStageBaseRun(
        distanceInKilometers: 10.0,
        maxHeartRate: 150,
      );

      state = state.copyWith(stageToSubmit: expectedStageToSubmit);
      final state2 = state.copyWith();

      expect(state.stageToSubmit, expectedStageToSubmit);
      expect(state2.stageToSubmit, null);
    },
  );
}
