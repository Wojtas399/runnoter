import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/workout_stage_creator/bloc/workout_stage_creator_bloc.dart';

void main() {
  late WorkoutStageCreatorState state;

  WorkoutStageCreatorState createState({
    BlocStatus status = const BlocStatusComplete(),
    WorkoutStageCreatorForm? form,
  }) =>
      WorkoutStageCreatorState(
        status: status,
        form: form,
      );

  setUp(() {
    state = createState();
  });

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
