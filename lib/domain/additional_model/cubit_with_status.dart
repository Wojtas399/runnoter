import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ui/model/cubit_state.dart';
import '../../ui/model/cubit_status.dart';

abstract class CubitWithStatus<State extends CubitState, Info, Error>
    extends Cubit<State> {
  CubitWithStatus(super.initialState);

  void emitLoadingStatus<T>({T? loadingInfo}) {
    emit(state.copyWith(
      status: CubitStatusLoading<T>(loadingInfo: loadingInfo),
    ));
  }

  void emitCompleteStatus({Info? info}) {
    CubitStatus status = const CubitStatusComplete();
    if (info != null) status = CubitStatusComplete<Info>(info: info);
    emit(state.copyWith(status: status));
  }

  void emitErrorStatus(Error error) {
    emit(state.copyWith(
      status: CubitStatusError<Error>(error: error),
    ));
  }

  void emitUnknownErrorStatus() {
    emit(state.copyWith(
      status: const CubitStatusUnknownError(),
    ));
  }

  void emitNoInternetConnectionStatus() {
    emit(state.copyWith(
      status: const CubitStatusNoInternetConnection(),
    ));
  }

  void emitNoLoggedUserStatus() {
    emit(state.copyWith(
      status: const CubitStatusNoLoggedUser(),
    ));
  }
}
