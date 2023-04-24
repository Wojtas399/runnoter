import 'package:bloc_test/bloc_test.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/day_preview/bloc/day_preview_bloc.dart';
import 'package:runnoter/presentation/screen/day_preview/bloc/day_preview_event.dart';
import 'package:runnoter/presentation/screen/day_preview/bloc/day_preview_state.dart';

void main() {
  DayPreviewBloc createBloc() {
    return DayPreviewBloc();
  }

  DayPreviewState createState({
    BlocStatus status = const BlocStatusInitial(),
    DateTime? date,
  }) {
    return DayPreviewState(
      status: status,
      date: date,
    );
  }

  blocTest(
    'initialize, '
    'should update date in state',
    build: () => createBloc(),
    act: (DayPreviewBloc bloc) {
      bloc.add(
        DayPreviewEventInitialize(
          date: DateTime(2023, 1, 10),
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        date: DateTime(2023, 1, 10),
      ),
    ],
  );
}
