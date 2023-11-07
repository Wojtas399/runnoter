import '../../../../../data/model/custom_exception.dart';
import '../../../../../dependency_injection.dart';
import '../../../data/service/auth/auth_service.dart';
import '../../model/cubit_state.dart';
import '../../model/cubit_status.dart';
import '../../model/cubit_with_status.dart';

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
    await _reauthenticateWithProvider(
      AuthProviderPassword(password: state.password!),
    );
  }

  Future<void> useGoogle() async {
    await _reauthenticateWithProvider(const AuthProviderGoogle());
  }

  Future<void> useFacebook() async {
    await _reauthenticateWithProvider(const AuthProviderFacebook());
  }

  Future<void> useApple() async {
    await _reauthenticateWithProvider(const AuthProviderApple());
  }

  Future<void> _reauthenticateWithProvider(AuthProvider authProvider) async {
    final ReauthenticationCubitLoadingInfo loadingInfo = switch (authProvider) {
      AuthProviderPassword() =>
        ReauthenticationCubitLoadingInfo.passwordReauthenticationLoading,
      AuthProviderGoogle() =>
        ReauthenticationCubitLoadingInfo.googleReauthenticationLoading,
      AuthProviderFacebook() =>
        ReauthenticationCubitLoadingInfo.facebookReauthenticationLoading,
      AuthProviderApple() =>
        ReauthenticationCubitLoadingInfo.appleReauthenticationLoading,
    };
    emitLoadingStatus(loadingInfo: loadingInfo);
    try {
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
  appleReauthenticationLoading,
}

enum ReauthenticationCubitInfo { userConfirmed }

enum ReauthenticationCubitError { wrongPassword, userMismatch }
