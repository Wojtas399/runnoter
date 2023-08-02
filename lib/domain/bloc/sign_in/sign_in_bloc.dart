import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../dependency_injection.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/custom_exception.dart';
import '../../entity/user.dart';
import '../../repository/user_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends BlocWithStatus<SignInEvent, SignInState,
    SignInBlocInfo, SignInBlocError> {
  final AuthService _authService;
  final UserRepository _userRepository;

  SignInBloc({
    BlocStatus status = const BlocStatusInitial(),
    String email = '',
    String password = '',
  })  : _authService = getIt<AuthService>(),
        _userRepository = getIt<UserRepository>(),
        super(
          SignInState(
            status: status,
            email: email,
            password: password,
          ),
        ) {
    on<SignInEventInitialize>(_initialize);
    on<SignInEventEmailChanged>(_emailChanged);
    on<SignInEventPasswordChanged>(_passwordChanged);
    on<SignInEventSubmit>(_submit);
    on<SignInEventSignInWithGoogle>(_signInWithGoogle);
    on<SignInEventSignInWithFacebook>(_signInWithFacebook);
    on<SignInEventDeleteRecentlyCreatedAccount>(_deleteRecentlyCreatedAccount);
  }

  Future<void> _initialize(
    SignInEventInitialize event,
    Emitter<SignInState> emit,
  ) async {
    emitLoadingStatus(emit);
    SignInBlocInfo? info;
    if (await _authService.loggedUserId$.first != null &&
        await _authService.hasLoggedUserVerifiedEmail$.first == true) {
      info = SignInBlocInfo.signedIn;
    }
    emitCompleteStatus(emit, info);
  }

  void _emailChanged(
    SignInEventEmailChanged event,
    Emitter<SignInState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
    ));
  }

  void _passwordChanged(
    SignInEventPasswordChanged event,
    Emitter<SignInState> emit,
  ) {
    emit(state.copyWith(
      password: event.password,
    ));
  }

  Future<void> _submit(
    SignInEventSubmit event,
    Emitter<SignInState> emit,
  ) async {
    if (state.isButtonDisabled) return;
    emitLoadingStatus(emit);
    try {
      await _authService.signIn(email: state.email, password: state.password);
      await _checkIfLoggedUserHasVerifiedEmail(emit);
    } on AuthException catch (authException) {
      final SignInBlocError? error = _mapAuthExceptionCodeToBlocError(
        authException.code,
      );
      if (error != null) {
        emitErrorStatus(emit, error);
      } else {
        emitUnknownErrorStatus(emit);
        rethrow;
      }
    } on NetworkException catch (networkException) {
      if (networkException.code == NetworkExceptionCode.requestFailed) {
        emitNetworkRequestFailed(emit);
      }
    } on UnknownException catch (unknownException) {
      emitUnknownErrorStatus(emit);
      throw unknownException.message;
    }
  }

  Future<void> _signInWithGoogle(
    SignInEventSignInWithGoogle event,
    Emitter<SignInState> emit,
  ) async {
    try {
      emitLoadingStatus(emit);
      final String? loggedUserId = await _authService.signInWithGoogle();
      if (loggedUserId == null) {
        emitCompleteStatus(emit, null);
        return;
      }
      await _checkIfLoggedUserDataExist(loggedUserId, emit);
    } on NetworkException catch (exception) {
      if (exception.code == NetworkExceptionCode.requestFailed) {
        emitNetworkRequestFailed(emit);
      }
    }
  }

  Future<void> _signInWithFacebook(
    SignInEventSignInWithFacebook event,
    Emitter<SignInState> emit,
  ) async {
    try {
      emitLoadingStatus(emit);
      final String? loggedUserId = await _authService.signInWithFacebook();
      if (loggedUserId == null) {
        emitCompleteStatus(emit, null);
        return;
      }
      await _checkIfLoggedUserDataExist(loggedUserId, emit);
    } on NetworkException catch (exception) {
      if (exception.code == NetworkExceptionCode.requestFailed) {
        emitNetworkRequestFailed(emit);
      }
    }
  }

  Future<void> _deleteRecentlyCreatedAccount(
    SignInEventDeleteRecentlyCreatedAccount event,
    Emitter<SignInState> emit,
  ) async {
    emitLoadingStatus(emit);
    await _authService.deleteAccount();
    emitCompleteStatus(emit, null);
  }

  SignInBlocError? _mapAuthExceptionCodeToBlocError(
    AuthExceptionCode authExceptionCode,
  ) {
    if (authExceptionCode == AuthExceptionCode.invalidEmail) {
      return SignInBlocError.invalidEmail;
    } else if (authExceptionCode == AuthExceptionCode.userNotFound) {
      return SignInBlocError.userNotFound;
    } else if (authExceptionCode == AuthExceptionCode.wrongPassword) {
      return SignInBlocError.wrongPassword;
    }
    return null;
  }

  Future<void> _checkIfLoggedUserDataExist(
    String loggedUserId,
    Emitter<SignInState> emit,
  ) async {
    final Stream<User?> loggedUser$ = _userRepository.getUserById(
      userId: loggedUserId,
    );
    await for (final loggedUser in loggedUser$) {
      if (loggedUser != null) {
        await _checkIfLoggedUserHasVerifiedEmail(emit);
      } else {
        emitCompleteStatus(emit, SignInBlocInfo.newSignedInUser);
      }
      return;
    }
  }

  Future<void> _checkIfLoggedUserHasVerifiedEmail(
    Emitter<SignInState> emit,
  ) async {
    final bool? hasLoggedUserVerifiedEmail =
        await _authService.hasLoggedUserVerifiedEmail$.first;
    if (hasLoggedUserVerifiedEmail == null) {
      emitCompleteStatus(emit, null);
      return;
    }
    if (hasLoggedUserVerifiedEmail == true) {
      emitCompleteStatus(emit, SignInBlocInfo.signedIn);
    } else {
      await _authService.sendEmailVerification();
      emitErrorStatus(emit, SignInBlocError.unverifiedEmail);
    }
  }
}

enum SignInBlocInfo { signedIn, newSignedInUser }

enum SignInBlocError {
  invalidEmail,
  unverifiedEmail,
  userNotFound,
  wrongPassword,
}
