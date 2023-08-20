import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/race_preview/race_preview_bloc.dart';
import 'package:runnoter/domain/entity/race.dart';

import '../../../creators/race_creator.dart';

void main() {
  late RacePreviewState state;

  setUp(
    () => state = const RacePreviewState(
      status: BlocStatusInitial(),
    ),
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
    'copy with canEditRaceStatus',
    () {
      const bool expected = false;

      state = state.copyWith(canEditRaceStatus: expected);
      final state2 = state.copyWith();

      expect(state.canEditRaceStatus, expected);
      expect(state2.canEditRaceStatus, expected);
    },
  );

  test(
    'copy with race',
    () {
      final Race expectedRace =
          createRace(id: 'c1', userId: 'u1', name: 'race name');

      state = state.copyWith(race: expectedRace);
      final state2 = state.copyWith();

      expect(state.race, expectedRace);
      expect(state2.race, expectedRace);
    },
  );
}
