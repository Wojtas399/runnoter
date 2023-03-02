import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_state.dart';
import 'bloc_status.dart';

abstract class BlocWithStatus<Event, State extends BlocState>
    extends Bloc<Event, State> {
  BlocWithStatus(super.initialState);

  void emitLoadingStatus(Emitter<State> emit) {
    emit(state.copyWith(
      status: const LoadingBlocStatus(),
    ));
  }

  void emitInfo<T>(Emitter<State> emit, T info) {
    emit(state.copyWith(
      status: CompleteBlocStatus<T>(info: info),
    ));
  }

  void emitError<T>(Emitter<State> emit, T error) {
    emit(state.copyWith(
      status: ErrorBlocStatus<T>(error: error),
    ));
  }
}
