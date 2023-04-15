import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';
import 'day_preview_event.dart';
import 'day_preview_state.dart';

class DayPreviewBloc
    extends BlocWithStatus<DayPreviewEvent, DayPreviewState, dynamic, dynamic> {
  DayPreviewBloc({
    BlocStatus status = const BlocStatusInitial(),
    DateTime? date,
  }) : super(
          DayPreviewState(
            status: status,
            date: date,
          ),
        ) {
    on<DayPreviewEventInitialize>(_initialize);
  }

  void _initialize(
    DayPreviewEventInitialize event,
    Emitter<DayPreviewState> emit,
  ) {
    emit(state.copyWith(
      date: event.date,
    ));
  }
}
