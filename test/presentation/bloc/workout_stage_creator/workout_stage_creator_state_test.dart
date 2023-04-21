import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/workout_stage_creator/bloc/workout_stage_creator_bloc.dart';

void main() {
  late WorkoutStageCreatorState state;

  WorkoutStageCreatorState createState({
    BlocStatus status = const BlocStatusComplete(),
    WorkoutStage? stageType,
    WorkoutStageCreatorForm? form,
  }) =>
      WorkoutStageCreatorState(
        status: status,
        stageType: stageType,
        form: form,
      );

  setUp(() {
    state = createState();
  });

  test(
    'is add button disabled, '
    'stage type is null, '
    'should be true',
    () {
      expect(state.isAddButtonDisabled, true);
    },
  );

  test(
    'is add button disabled, '
    'stage type is not null and distance stage form data are invalid, '
    'should be true',
    () {
      const WorkoutStage stageType = WorkoutStage.baseRun;
      const distanceForm = WorkoutStageCreatorDistanceStageForm(
        distanceInKm: 0,
        maxHeartRate: 140,
      );

      state = createState(
        stageType: stageType,
        form: distanceForm,
      );

      expect(state.isAddButtonDisabled, true);
    },
  );

  test(
    'is add button disabled, '
    'stage type is not null and distance stage form data are valid, '
    'should be false',
    () {
      const WorkoutStage stageType = WorkoutStage.baseRun;
      const distanceForm = WorkoutStageCreatorDistanceStageForm(
        distanceInKm: 10.5,
        maxHeartRate: 140,
      );

      state = createState(
        stageType: stageType,
        form: distanceForm,
      );

      expect(state.isAddButtonDisabled, false);
    },
  );

  test(
    'is add button disabled, '
    'stage type is not null and series stage form data are invalid, '
    'should be true',
    () {
      const WorkoutStage stageType = WorkoutStage.hillRepeats;
      const distanceForm = WorkoutStageCreatorSeriesStageForm(
        amountOfSeries: 0,
        seriesDistanceInMeters: 100,
        breakWalkingDistanceInMeters: 20,
        breakJoggingDistanceInMeters: 80,
      );

      state = createState(
        stageType: stageType,
        form: distanceForm,
      );

      expect(state.isAddButtonDisabled, true);
    },
  );

  test(
    'is add button disabled, '
    'stage type is not null and series stage form data are valid, '
    'should be false',
    () {
      const WorkoutStage stageType = WorkoutStage.hillRepeats;
      const distanceForm = WorkoutStageCreatorSeriesStageForm(
        amountOfSeries: 10,
        seriesDistanceInMeters: 100,
        breakWalkingDistanceInMeters: 20,
        breakJoggingDistanceInMeters: 80,
      );

      state = createState(
        stageType: stageType,
        form: distanceForm,
      );

      expect(state.isAddButtonDisabled, false);
    },
  );

  test(
    'is add button disabled, '
    'stage type is not null and form is null, '
    'should be false',
    () {
      const WorkoutStage stageType = WorkoutStage.stretching;

      state = createState(
        stageType: stageType,
      );

      expect(state.isAddButtonDisabled, false);
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
      const WorkoutStage expectedStageType = WorkoutStage.hillRepeats;

      state = state.copyWith(stageType: expectedStageType);
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

      state = state.copyWith(form: expectedForm);
      final state2 = state.copyWith();

      expect(state.form, expectedForm);
      expect(state2.form, null);
    },
  );
}
