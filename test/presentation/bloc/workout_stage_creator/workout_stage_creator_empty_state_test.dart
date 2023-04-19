import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/workout_stage_creator/bloc/workout_stage_creator_empty_state.dart';

void main() {
  late WorkoutStageCreatorEmptyState state;

  setUp(() {
    state = const WorkoutStageCreatorEmptyState(
      status: BlocStatusComplete(),
    );
  });

  test(
    'are data correct, '
    'should always return true',
    () {
      expect(state.areDataCorrect, true);
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
}
