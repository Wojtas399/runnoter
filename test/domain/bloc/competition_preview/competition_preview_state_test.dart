import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/competition_preview/competition_preview_bloc.dart';
import 'package:runnoter/domain/entity/competition.dart';

import '../../../creators/competition_creator.dart';

void main() {
  late CompetitionPreviewState state;

  setUp(
    () => state = const CompetitionPreviewState(
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
    'copy with competition',
    () {
      final Competition expectedCompetition =
          createCompetition(id: 'c1', userId: 'u1', name: 'competition name');

      state = state.copyWith(competition: expectedCompetition);
      final state2 = state.copyWith();

      expect(state.competition, expectedCompetition);
      expect(state2.competition, expectedCompetition);
    },
  );
}
