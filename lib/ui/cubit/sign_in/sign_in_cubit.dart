import '../../../../../data/model/custom_exception.dart';
import '../../../../../dependency_injection.dart';
import '../../../data/model/user.dart';
import '../../../data/repository/user/user_repository.dart';
import '../../../data/service/auth/auth_service.dart';
import '../../model/cubit_state.dart';
import '../../model/cubit_status.dart';
import '../../model/cubit_with_status.dart';

part 'sign_in_state.dart';

class SignInCubit
    extends CubitWithStatus<SignInState, SignInCubitInfo, SignInCubitError> {
  final AuthService _authService;
  final UserRepository _userRepository;

  SignInCubit({
    SignInState initialState = const SignInState(status: CubitStatusInitial()),
  })  : _authService = getIt<AuthService>(),
        _userRepository = getIt<UserRepository>(),
        super(initialState);

  Future<void> initialize() async {
    emitLoadingStatus();
    SignInCubitInfo? info;
    if (await _authService.loggedUserId$.first != null &&
        await _authService.hasLoggedUserVerifiedEmail$.first == true) {
      info = SignInCubitInfo.signedIn;
    }
    emitCompleteStatus(info: info);
  }

  void emailChanged(String email) {
    emit(state.copyWith(email: email));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(password: password));
  }

  Future<void> submit() async {
    if (!state.canSubmit) return;
    emitLoadingStatus();
    try {
      await _authService.signIn(email: state.email, password: state.password);
      await _checkIfLoggedUserHasVerifiedEmail();
    } on AuthException catch (authException) {
      final SignInCubitError? error = _mapAuthExceptionCodeToBlocError(
        authException.code,
      );
      if (error != null) {
        emitErrorStatus(error);
      } else {
        emitUnknownErrorStatus();
        rethrow;
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

  Future<void> signInWithGoogle() async {
    try {
      emitLoadingStatus();
      final String? loggedUserId = await _authService.signInWithGoogle();
      if (loggedUserId == null) {
        emitCompleteStatus();
        return;
      }
      await _checkIfLoggedUserDataExist(loggedUserId);
    } on NetworkException catch (exception) {
      if (exception.code == NetworkExceptionCode.requestFailed) {
        emitNoInternetConnectionStatus();
      }
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      emitLoadingStatus();
      final String? loggedUserId = await _authService.signInWithFacebook();
      if (loggedUserId == null) {
        emitCompleteStatus();
        return;
      }
      await _checkIfLoggedUserDataExist(loggedUserId);
    } on NetworkException catch (exception) {
      if (exception.code == NetworkExceptionCode.requestFailed) {
        emitNoInternetConnectionStatus();
      }
    }
  }

  Future<void> signInWithApple() async {
    try {
      emitLoadingStatus();
      final String? loggedUserId = await _authService.signInWithApple();
      if (loggedUserId == null) {
        emitCompleteStatus();
        return;
      }
      await _checkIfLoggedUserDataExist(loggedUserId);
    } on NetworkException catch (exception) {
      if (exception.code == NetworkExceptionCode.requestFailed) {
        emitNoInternetConnectionStatus();
      }
    }
  }

  Future<void> deleteRecentlyCreatedAccount() async {
    emitLoadingStatus();
    await _authService.deleteAccount();
    emitCompleteStatus();
  }

  SignInCubitError? _mapAuthExceptionCodeToBlocError(
    AuthExceptionCode authExceptionCode,
  ) =>
      switch (authExceptionCode) {
        AuthExceptionCode.invalidEmail => SignInCubitError.invalidEmail,
        AuthExceptionCode.userNotFound => SignInCubitError.userNotFound,
        AuthExceptionCode.wrongPassword => SignInCubitError.wrongPassword,
        _ => null,
      };

  Future<void> _checkIfLoggedUserDataExist(String loggedUserId) async {
    final Stream<User?> loggedUser$ =
        _userRepository.getUserById(userId: loggedUserId);
    await for (final loggedUser in loggedUser$) {
      if (loggedUser != null) {
        await _checkIfLoggedUserHasVerifiedEmail();
      } else {
        emitCompleteStatus(info: SignInCubitInfo.newSignedInUser);
      }
      return;
    }
  }

  Future<void> _checkIfLoggedUserHasVerifiedEmail() async {
    final bool? hasLoggedUserVerifiedEmail =
        await _authService.hasLoggedUserVerifiedEmail$.first;
    if (hasLoggedUserVerifiedEmail == null) {
      emitCompleteStatus();
      return;
    }
    if (hasLoggedUserVerifiedEmail == true) {
      emitCompleteStatus(info: SignInCubitInfo.signedIn);
    } else {
      await _authService.sendEmailVerification();
      emitErrorStatus(SignInCubitError.unverifiedEmail);
    }
  }
}

enum SignInCubitInfo { signedIn, newSignedInUser }

enum SignInCubitError {
  invalidEmail,
  unverifiedEmail,
  userNotFound,
  wrongPassword
}
