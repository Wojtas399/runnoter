import '../../../data/interface/service/auth_service.dart';
import '../../../dependency_injection.dart';
import '../../additional_model/auth_provider.dart';
import '../../additional_model/cubit_state.dart';
import '../../additional_model/cubit_status.dart';
import '../../additional_model/cubit_with_status.dart';
import '../../additional_model/custom_exception.dart';

part 'reauthentication_state.dart';

class ReauthenticationCubit extends CubitWithStatus<ReauthenticationState,
    ReauthenticationCubitInfo, ReauthenticationCubitError> {
  final AuthService _authService;

  ReauthenticationCubit({
    ReauthenticationState initialState = const ReauthenticationState(
      status: CubitStatusInitial(),
    ),
  })  : _authService = getIt<AuthService>(),
        super(initialState);

  void passwordChanged(String password) {
    emit(state.copyWith(password: password));
  }

  Future<void> usePassword() async {
    final String? password = state.password;
    if (password == null || password.isEmpty) return;
    emitLoadingStatus(
      loadingInfo:
          ReauthenticationCubitLoadingInfo.passwordReauthenticationLoading,
    );
    try {
      final authProvider = AuthProviderPassword(password: state.password!);
      final ReauthenticationStatus reauthenticationStatus =
          await _authService.reauthenticate(authProvider: authProvider);
      _manageReauthenticationStatus(reauthenticationStatus);
    } on AuthException catch (authException) {
      if (authException.code == AuthExceptionCode.wrongPassword) {
        emitErrorStatus(ReauthenticationCubitError.wrongPassword);
      }
    } on NetworkException catch (networkException) {
      if (networkException.code == NetworkExceptionCode.requestFailed) {
        emitNoInternetConnectionStatus();
      }
    }
  }

  Future<void> useGoogle() async {
    emitLoadingStatus(
      loadingInfo:
          ReauthenticationCubitLoadingInfo.googleReauthenticationLoading,
    );
    try {
      final ReauthenticationStatus reauthenticationStatus = await _authService
          .reauthenticate(authProvider: const AuthProviderGoogle());
      _manageReauthenticationStatus(reauthenticationStatus);
    } on NetworkException catch (networkException) {
      if (networkException.code == NetworkExceptionCode.requestFailed) {
        emitNoInternetConnectionStatus();
      }
    }
  }

  Future<void> useFacebook() async {
    emitLoadingStatus(
      loadingInfo:
          ReauthenticationCubitLoadingInfo.facebookReauthenticationLoading,
    );
    try {
      final ReauthenticationStatus reauthenticationStatus = await _authService
          .reauthenticate(authProvider: const AuthProviderFacebook());
      _manageReauthenticationStatus(reauthenticationStatus);
    } on NetworkException catch (networkException) {
      if (networkException.code == NetworkExceptionCode.requestFailed) {
        emitNoInternetConnectionStatus();
      }
    }
  }

  void _manageReauthenticationStatus(
    ReauthenticationStatus reauthenticationStatus,
  ) {
    switch (reauthenticationStatus) {
      case ReauthenticationStatus.confirmed:
        emitCompleteStatus(info: ReauthenticationCubitInfo.userConfirmed);
      case ReauthenticationStatus.cancelled:
        emitCompleteStatus();
      case ReauthenticationStatus.userMismatch:
        emitErrorStatus(ReauthenticationCubitError.userMismatch);
    }
  }
}

enum ReauthenticationCubitLoadingInfo {
  passwordReauthenticationLoading,
  googleReauthenticationLoading,
  facebookReauthenticationLoading,
}

enum ReauthenticationCubitInfo { userConfirmed }

enum ReauthenticationCubitError { wrongPassword, userMismatch }
