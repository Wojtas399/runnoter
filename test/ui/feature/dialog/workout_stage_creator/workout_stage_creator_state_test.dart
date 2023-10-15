import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/additional_model/workout_stage.dart';
import 'package:runnoter/ui/feature/dialog/workout_stage_creator/cubit/workout_stage_creator_cubit.dart';

void main() {
  late WorkoutStageCreatorState state;

  setUp(
    () => state = const WorkoutStageCreatorState(),
  );

  test(
    'is edit mode, '
    'original workout stage is not null in distance form, '
    'should be true',
    () {
      state = state.copyWith(
        distanceForm: const WorkoutStageCreatorDistanceForm(
          originalStage: WorkoutStageZone2(
            distanceInKm: 10,
            maxHeartRate: 165,
          ),
        ),
      );

      expect(state.isEditMode, true);
    },
  );

  test(
    'is edit mode, '
    'original workout stage is not null in series form, '
    'should be true',
    () {
      state = state.copyWith(
        seriesForm: const WorkoutStageCreatorSeriesForm(
          originalStage: WorkoutStageRhythms(
            amountOfSeries: 10,
            seriesDistanceInMeters: 100,
            walkingDistanceInMeters: 20,
            joggingDistanceInMeters: 80,
          ),
        ),
      );

      expect(state.isEditMode, true);
    },
  );

  test(
    'is edit mode, '
    'original workout stage is null in both forms, '
    'should be false',
    () {
      expect(state.isEditMode, false);
    },
  );

  test(
    'is submit button disabled, '
    'stage type is null, '
    'should be true',
    () {
      state = state.copyWith(
        stageType: null,
        distanceForm: const WorkoutStageCreatorDistanceForm(
          distanceInKm: 10,
          maxHeartRate: 150,
        ),
      );

      expect(state.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'stage type is same as original, '
    'should be true',
    () {
      state = state.copyWith(
        originalStageType: WorkoutStageType.zone2,
        stageType: WorkoutStageType.zone2,
      );

      expect(state.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'original stage type is not null and stage type is different original, '
    'should be false',
    () {
      state = state.copyWith(
        originalStageType: WorkoutStageType.zone2,
        stageType: WorkoutStageType.zone3,
        distanceForm: const WorkoutStageCreatorDistanceForm(
          originalStage: WorkoutStageCardio(
            distanceInKm: 10,
            maxHeartRate: 150,
          ),
          distanceInKm: 10,
          maxHeartRate: 150,
        ),
      );

      expect(state.isSubmitButtonDisabled, false);
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

      state = state.copyWith(
        originalStageType: stageType,
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

      state = state.copyWith(
        originalStageType: stageType,
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

      state = state.copyWith(
        originalStageType: stageType,
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

      state = state.copyWith(
        originalStageType: stageType,
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
    'copy with originalStageType, '
    'should copy current value if new value is null',
    () {
      const WorkoutStageType expected = WorkoutStageType.rhythms;

      state = state.copyWith(originalStageType: expected);
      final state2 = state.copyWith();

      expect(state.originalStageType, expected);
      expect(state2.originalStageType, expected);
    },
  );

  test(
    'copy with stageType, '
    'should copy current value if new value is null',
    () {
      const WorkoutStageType expected = WorkoutStageType.hillRepeats;

      state = state.copyWith(stageType: expected);
      final state2 = state.copyWith();

      expect(state.stageType, expected);
      expect(state2.stageType, expected);
    },
  );

  test(
    'copy with distanceForm, '
    'should copy current value if new value is null',
    () {
      const expected = WorkoutStageCreatorDistanceForm(
        originalStage: WorkoutStageZone2(
          distanceInKm: 5,
          maxHeartRate: 165,
        ),
        distanceInKm: 6.0,
        maxHeartRate: 165,
      );

      state = state.copyWith(distanceForm: expected);
      final state2 = state.copyWith();

      expect(state.distanceForm, expected);
      expect(state2.distanceForm, expected);
    },
  );

  test(
    'copy with seriesForm, '
    'should copy current value if new value is null',
    () {
      const expected = WorkoutStageCreatorSeriesForm(
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

      state = state.copyWith(seriesForm: expected);
      final state2 = state.copyWith();

      expect(state.seriesForm, expected);
      expect(state2.seriesForm, expected);
    },
  );

  test(
    'copy with stageToAdd, '
    'should copy current value if new value is null',
    () {
      const WorkoutStage expected = WorkoutStageCardio(
        distanceInKm: 10.0,
        maxHeartRate: 150,
      );

      state = state.copyWith(stageToAdd: expected);
      final state2 = state.copyWith();

      expect(state.stageToAdd, expected);
      expect(state2.stageToAdd, null);
    },
  );
}
