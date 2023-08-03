import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_state.dart';
import 'bloc_status.dart';

abstract class BlocWithStatus<Event, State extends BlocState, Info, Error>
    extends Bloc<Event, State> {
  BlocWithStatus(super.initialState);

  void emitLoadingStatus<T>(Emitter<State> emit, {T? loadingInfo}) {
    emit(state.copyWith(
      status: BlocStatusLoading<T>(loadingInfo: loadingInfo),
    ));
  }

  void emitCompleteStatus(Emitter<State> emit, Info? info) {
    emit(state.copyWith(
      status: BlocStatusComplete<Info>(info: info),
    ));
  }

  void emitErrorStatus(Emitter<State> emit, Error error) {
    emit(state.copyWith(
      status: BlocStatusError<Error>(error: error),
    ));
  }

  void emitUnknownErrorStatus(Emitter<State> emit) {
    emit(state.copyWith(
      status: const BlocStatusUnknownError(),
    ));
  }

  void emitNoInternetConnectionStatus(Emitter<State> emit) {
    emit(state.copyWith(
      status: const BlocStatusNoInternetConnection(),
    ));
  }

  void emitNoLoggedUserStatus(Emitter<State> emit) {
    emit(state.copyWith(
      status: const BlocStatusNoLoggedUser(),
    ));
  }
}
