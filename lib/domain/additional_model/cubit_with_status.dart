import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_status.dart';
import 'cubit_state.dart';

abstract class CubitWithStatus<State extends CubitState, Info, Error>
    extends Cubit<State> {
  CubitWithStatus(super.initialState);

  void emitLoadingStatus<T>({T? loadingInfo}) {
    emit(state.copyWith(
      status: BlocStatusLoading<T>(loadingInfo: loadingInfo),
    ));
  }

  void emitCompleteStatus({Info? info}) {
    BlocStatus status = const BlocStatusComplete();
    if (info != null) status = BlocStatusComplete<Info>(info: info);
    emit(state.copyWith(status: status));
  }

  void emitErrorStatus(Error error) {
    emit(state.copyWith(
      status: BlocStatusError<Error>(error: error),
    ));
  }

  void emitUnknownErrorStatus() {
    emit(state.copyWith(
      status: const BlocStatusUnknownError(),
    ));
  }

  void emitNoInternetConnectionStatus() {
    emit(state.copyWith(
      status: const BlocStatusNoInternetConnection(),
    ));
  }

  void emitNoLoggedUserStatus() {
    emit(state.copyWith(
      status: const BlocStatusNoLoggedUser(),
    ));
  }
}
