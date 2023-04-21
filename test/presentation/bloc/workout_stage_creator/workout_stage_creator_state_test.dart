import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/presentation/screen/workout_stage_creator/bloc/workout_stage_creator_bloc.dart';

void main() {
  WorkoutStageCreatorStateInProgress createStateInProgress({
    WorkoutStageType? stageType,
    WorkoutStageCreatorForm? form,
  }) =>
      WorkoutStageCreatorStateInProgress(
        stageType: stageType,
        form: form,
      );

  test(
    'state in progress, '
    'is add button disabled, '
    'stage type is null, '
    'should be true',
    () {
      final state = createStateInProgress();

      expect(state.isAddButtonDisabled, true);
    },
  );

  test(
    'state in progress, '
    'is add button disabled, '
    'stage type is not null and distance stage form data are invalid, '
    'should be true',
    () {
      const WorkoutStageType stageType = WorkoutStageType.baseRun;
      const distanceForm = WorkoutStageCreatorDistanceStageForm(
        distanceInKm: 0,
        maxHeartRate: 140,
      );

      final state = createStateInProgress(
        stageType: stageType,
        form: distanceForm,
      );

      expect(state.isAddButtonDisabled, true);
    },
  );

  test(
    'state in progress, '
    'is add button disabled, '
    'stage type is not null and distance stage form data are valid, '
    'should be false',
    () {
      const WorkoutStageType stageType = WorkoutStageType.baseRun;
      const distanceForm = WorkoutStageCreatorDistanceStageForm(
        distanceInKm: 10.5,
        maxHeartRate: 140,
      );

      final state = createStateInProgress(
        stageType: stageType,
        form: distanceForm,
      );

      expect(state.isAddButtonDisabled, false);
    },
  );

  test(
    'state in progress, '
    'is add button disabled, '
    'stage type is not null and series stage form data are invalid, '
    'should be true',
    () {
      const WorkoutStageType stageType = WorkoutStageType.hillRepeats;
      const distanceForm = WorkoutStageCreatorSeriesStageForm(
        amountOfSeries: 0,
        seriesDistanceInMeters: 100,
        breakWalkingDistanceInMeters: 20,
        breakJoggingDistanceInMeters: 80,
      );

      final state = createStateInProgress(
        stageType: stageType,
        form: distanceForm,
      );

      expect(state.isAddButtonDisabled, true);
    },
  );

  test(
    'state in progress, '
    'is add button disabled, '
    'stage type is not null and series stage form data are valid, '
    'should be false',
    () {
      const WorkoutStageType stageType = WorkoutStageType.hillRepeats;
      const distanceForm = WorkoutStageCreatorSeriesStageForm(
        amountOfSeries: 10,
        seriesDistanceInMeters: 100,
        breakWalkingDistanceInMeters: 20,
        breakJoggingDistanceInMeters: 80,
      );

      final state = createStateInProgress(
        stageType: stageType,
        form: distanceForm,
      );

      expect(state.isAddButtonDisabled, false);
    },
  );

  test(
    'state in progress, '
    'is add button disabled, '
    'stage type is not null and form is null, '
    'should be false',
    () {
      const WorkoutStageType stageType = WorkoutStageType.stretching;

      final state = createStateInProgress(
        stageType: stageType,
      );

      expect(state.isAddButtonDisabled, false);
    },
  );

  test(
    'copy with stage type',
    () {
      const WorkoutStageType expectedStageType = WorkoutStageType.hillRepeats;

      final state = createStateInProgress(stageType: expectedStageType);
      final state2 = state.copyWith();

      expect(state.stageType, expectedStageType);
      expect(state2.stageType, expectedStageType);
    },
  );

  test(
    'copy with form',
    () {
      const WorkoutStageCreatorForm expectedForm =
          WorkoutStageCreatorDistanceStageForm(
        distanceInKm: 10.0,
        maxHeartRate: 150,
      );

      final state = createStateInProgress(form: expectedForm);
      final state2 = state.copyWith();

      expect(state.form, expectedForm);
      expect(state2.form, null);
    },
  );
}
