import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runnoter/domain/model/auth_exception.dart';
import 'package:runnoter/domain/service/auth_service.dart';
import 'package:runnoter/presentation/model/bloc_state.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/model/bloc_with_status.dart';
import 'package:runnoter/presentation/service/validation_service.dart'
    as validator;

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc
    extends BlocWithStatus<SignUpEvent, SignUpState, SignUpInfo, SignUpError> {
  final AuthService _authService;

  SignUpBloc({
    required AuthService authService,
    BlocStatus status = const BlocStatusInitial(),
    String name = '',
    String surname = '',
    String email = '',
    String password = '',
    String passwordConfirmation = '',
  })  : _authService = authService,
        super(
          SignUpState(
            status: status,
            name: name,
            surname: surname,
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation,
          ),
        ) {
    on<SignUpEventNameChanged>(_nameChanged);
    on<SignUpEventSurnameChanged>(_surnameChanged);
    on<SignUpEventEmailChanged>(_emailChanged);
    on<SignUpEventPasswordChanged>(_passwordChanged);
    on<SignUpEventPasswordConfirmationChanged>(_passwordConfirmationChanged);
    on<SignUpEventSubmit>(_submit);
  }

  void _nameChanged(
    SignUpEventNameChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(
      name: event.name,
    ));
  }

  void _surnameChanged(
    SignUpEventSurnameChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(
      surname: event.surname,
    ));
  }

  void _emailChanged(
    SignUpEventEmailChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
    ));
  }

  void _passwordChanged(
    SignUpEventPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(
      password: event.password,
    ));
  }

  void _passwordConfirmationChanged(
    SignUpEventPasswordConfirmationChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(
      passwordConfirmation: event.passwordConfirmation,
    ));
  }

  Future<void> _submit(
    SignUpEventSubmit event,
    Emitter<SignUpState> emit,
  ) async {
    try {
      emitLoadingStatus(emit);
      await _authService.signUp(
        name: state.name,
        surname: state.surname,
        email: state.email,
        password: state.password,
      );
      emitCompleteStatus(emit, SignUpInfo.signedUp);
    } on AuthException catch (authException) {
      if (authException.code == AuthExceptionCode.emailAlreadyInUse) {
        emitErrorStatus(emit, SignUpError.emailAlreadyTaken);
      } else {
        rethrow;
      }
    }
  }
}
