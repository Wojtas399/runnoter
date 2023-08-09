import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../additional_model/auth_provider.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/bloc_with_status.dart';
import '../../additional_model/custom_exception.dart';
import '../../service/auth_service.dart';

part 'reauthentication_event.dart';
part 'reauthentication_state.dart';

class ReauthenticationBloc extends BlocWithStatus<
    ReauthenticationEvent,
    ReauthenticationState,
    ReauthenticationBlocInfo,
    ReauthenticationBlocError> {
  final AuthService _authService;

  ReauthenticationBloc({
    ReauthenticationState state = const ReauthenticationState(
      status: BlocStatusInitial(),
    ),
  })  : _authService = getIt<AuthService>(),
        super(state) {
    on<ReauthenticationEventPasswordChanged>(_passwordChanged);
    on<ReauthenticationEventUsePassword>(_usePassword);
    on<ReauthenticationEventUseGoogle>(_useGoogle);
    on<ReauthenticationEventUseFacebook>(_useFacebook);
  }

  void _passwordChanged(
    ReauthenticationEventPasswordChanged event,
    Emitter<ReauthenticationState> emit,
  ) {
    emit(state.copyWith(
      password: event.password,
    ));
  }

  Future<void> _usePassword(
    ReauthenticationEventUsePassword event,
    Emitter<ReauthenticationState> emit,
  ) async {
    final String? password = state.password;
    if (password == null || password.isEmpty) return;
    emitLoadingStatus(
      emit,
      loadingInfo:
          ReauthenticationBlocLoadingInfo.passwordReauthenticationLoading,
    );
    try {
      final authProvider = AuthProviderPassword(password: state.password!);
      final ReauthenticationStatus reauthenticationStatus =
          await _authService.reauthenticate(authProvider: authProvider);
      _manageReauthenticationStatus(reauthenticationStatus, emit);
    } on AuthException catch (authException) {
      if (authException.code == AuthExceptionCode.wrongPassword) {
        emitErrorStatus(emit, ReauthenticationBlocError.wrongPassword);
      }
    } on NetworkException catch (networkException) {
      if (networkException.code == NetworkExceptionCode.requestFailed) {
        emitNoInternetConnectionStatus(emit);
      }
    }
  }

  Future<void> _useGoogle(
    ReauthenticationEventUseGoogle event,
    Emitter<ReauthenticationState> emit,
  ) async {
    emitLoadingStatus(
      emit,
      loadingInfo:
          ReauthenticationBlocLoadingInfo.googleReauthenticationLoading,
    );
    try {
      final ReauthenticationStatus reauthenticationStatus = await _authService
          .reauthenticate(authProvider: const AuthProviderGoogle());
      _manageReauthenticationStatus(reauthenticationStatus, emit);
    } on NetworkException catch (networkException) {
      if (networkException.code == NetworkExceptionCode.requestFailed) {
        emitNoInternetConnectionStatus(emit);
      }
    }
  }

  Future<void> _useFacebook(
    ReauthenticationEventUseFacebook event,
    Emitter<ReauthenticationState> emit,
  ) async {
    emitLoadingStatus(
      emit,
      loadingInfo:
          ReauthenticationBlocLoadingInfo.facebookReauthenticationLoading,
    );
    try {
      final ReauthenticationStatus reauthenticationStatus = await _authService
          .reauthenticate(authProvider: const AuthProviderFacebook());
      _manageReauthenticationStatus(reauthenticationStatus, emit);
    } on NetworkException catch (networkException) {
      if (networkException.code == NetworkExceptionCode.requestFailed) {
        emitNoInternetConnectionStatus(emit);
      }
    }
  }

  void _manageReauthenticationStatus(
    ReauthenticationStatus reauthenticationStatus,
    Emitter<ReauthenticationState> emit,
  ) {
    switch (reauthenticationStatus) {
      case ReauthenticationStatus.confirmed:
        emitCompleteStatus(emit, info: ReauthenticationBlocInfo.userConfirmed);
        break;
      case ReauthenticationStatus.cancelled:
        emitCompleteStatus(emit);
        break;
      case ReauthenticationStatus.userMismatch:
        emitErrorStatus(emit, ReauthenticationBlocError.userMismatch);
        break;
    }
  }
}

enum ReauthenticationBlocLoadingInfo {
  passwordReauthenticationLoading,
  googleReauthenticationLoading,
  facebookReauthenticationLoading,
}

enum ReauthenticationBlocInfo { userConfirmed }

enum ReauthenticationBlocError { wrongPassword, userMismatch }
