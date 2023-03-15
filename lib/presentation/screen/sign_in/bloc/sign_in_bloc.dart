import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/model/auth_exception.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';
import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInBloc
    extends BlocWithStatus<SignInEvent, SignInState, SignInInfo, SignInError> {
  final AuthService _authService;

  SignInBloc({
    required AuthService authService,
    BlocStatus status = const BlocStatusInitial(),
    String email = '',
    String password = '',
  })  : _authService = authService,
        super(
          SignInState(
            status: status,
            email: email,
            password: password,
          ),
        ) {
    on<SignInEventEmailChanged>(_emailChanged);
    on<SignInEventPasswordChanged>(_passwordChanged);
    on<SignInEventSubmit>(_submit);
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
    if (state.email.isNotEmpty && state.password.isNotEmpty) {
      try {
        emitLoadingStatus(emit);
        await _authService.signIn(
          email: state.email,
          password: state.password,
        );
        emitCompleteStatus(emit, SignInInfo.signedIn);
      } on AuthException catch (authException) {
        SignInError? error;
        if (authException == AuthException.invalidEmail) {
          error = SignInError.invalidEmail;
        } else if (authException == AuthException.userNotFound) {
          error = SignInError.userNotFound;
        } else if (authException == AuthException.wrongPassword) {
          error = SignInError.userNotFound;
        }
        if (error != null) {
          emitErrorStatus(emit, error);
        } else {
          rethrow;
        }
      }
    }
  }
}
