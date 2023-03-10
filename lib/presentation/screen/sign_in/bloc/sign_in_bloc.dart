import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runnoter/domain/model/auth_exception.dart';
import 'package:runnoter/domain/service/auth_service.dart';
import 'package:runnoter/presentation/model/bloc_state.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/model/bloc_with_status.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

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
        if (authException.code == AuthExceptionCode.invalidEmail) {
          error = SignInError.invalidEmail;
        } else if (authException.code == AuthExceptionCode.userNotFound) {
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
