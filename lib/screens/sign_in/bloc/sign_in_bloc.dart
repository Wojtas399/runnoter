import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/auth.dart';
import '../../../model/auth_exception.dart';
import '../../../model/bloc_state.dart';
import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc
    extends BlocWithStatus<SignInEvent, SignInState, SignInInfo, SignInError> {
  final Auth _auth;

  SignInBloc({
    required Auth auth,
    BlocStatus status = const BlocStatusInitial(),
    String email = '',
    String password = '',
  })  : _auth = auth,
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
        await _auth.signIn(
          email: state.email,
          password: state.password,
        );
        emitCompleteStatus(emit, SignInInfo.signedIn);
      } on AuthException catch (authException) {
        SignInError? error;
        if (authException.code == AuthExceptionCode.userNotFound) {
          error = SignInError.userNotFound;
        } else if (authException.code == AuthExceptionCode.wrongPassword) {
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
