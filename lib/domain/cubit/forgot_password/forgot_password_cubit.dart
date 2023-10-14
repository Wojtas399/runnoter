import '../../../../domain/additional_model/cubit_status.dart';
import '../../../data/additional_model/custom_exception.dart';
import '../../../data/interface/service/auth_service.dart';
import '../../../dependency_injection.dart';
import '../../additional_model/cubit_state.dart';
import '../../additional_model/cubit_with_status.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends CubitWithStatus<ForgotPasswordState,
    ForgotPasswordCubitInfo, ForgotPasswordCubitError> {
  final AuthService _authService;

  ForgotPasswordCubit({
    ForgotPasswordState initialState = const ForgotPasswordState(
      status: CubitStatusInitial(),
    ),
  })  : _authService = getIt<AuthService>(),
        super(initialState);

  void emailChanged(String email) {
    emit(state.copyWith(email: email));
  }

  Future<void> submit() async {
    emitLoadingStatus();
    try {
      await _authService.sendPasswordResetEmail(email: state.email);
      emitCompleteStatus(info: ForgotPasswordCubitInfo.emailSubmitted);
    } on AuthException catch (authException) {
      final ForgotPasswordCubitError? error = _mapAuthExceptionCodeToBlocError(
        authException.code,
      );
      if (error != null) {
        emitErrorStatus(error);
      } else {
        emitUnknownErrorStatus();
      }
    } on NetworkException catch (networkException) {
      if (networkException.code == NetworkExceptionCode.requestFailed) {
        emitNoInternetConnectionStatus();
      }
    } on UnknownException catch (_) {
      emitUnknownErrorStatus();
      rethrow;
    }
  }

  ForgotPasswordCubitError? _mapAuthExceptionCodeToBlocError(
    AuthExceptionCode authExceptionCode,
  ) =>
      switch (authExceptionCode) {
        AuthExceptionCode.invalidEmail => ForgotPasswordCubitError.invalidEmail,
        AuthExceptionCode.userNotFound => ForgotPasswordCubitError.userNotFound,
        _ => null,
      };
}

enum ForgotPasswordCubitInfo { emailSubmitted }

enum ForgotPasswordCubitError { invalidEmail, userNotFound }
