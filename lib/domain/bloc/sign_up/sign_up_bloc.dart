import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/entity/settings.dart';
import '../../../../domain/entity/user.dart';
import '../../../../domain/repository/user_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../presentation/service/validation_service.dart' as validator;
import '../../additional_model/bloc_state.dart';
import '../../additional_model/custom_exception.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends BlocWithStatus<SignUpEvent, SignUpState,
    SignUpBlocInfo, SignUpBlocError> {
  final AuthService _authService;
  final UserRepository _userRepository;

  SignUpBloc({
    required AuthService authService,
    required UserRepository userRepository,
    BlocStatus status = const BlocStatusInitial(),
    String name = '',
    String surname = '',
    String email = '',
    String password = '',
    String passwordConfirmation = '',
  })  : _authService = authService,
        _userRepository = userRepository,
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
    emitLoadingStatus(emit);
    try {
      await _tryToSignUp();
      emitCompleteStatus(emit, SignUpBlocInfo.signedUp);
    } on AuthException catch (authException) {
      final SignUpBlocError? error = _mapAuthExceptionCodeToBlocError(
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

  Future<void> _tryToSignUp() async {
    final String? userId = await _authService.signUp(
      email: state.email,
      password: state.password,
    );
    if (userId == null) {
      return;
    }
    await _userRepository.addUser(
      user: User(
        id: userId,
        name: state.name,
        surname: state.surname,
        settings: const Settings(
          themeMode: ThemeMode.system,
          language: Language.polish,
          distanceUnit: DistanceUnit.kilometers,
          paceUnit: PaceUnit.minutesPerKilometer,
        ),
      ),
    );
  }

  SignUpBlocError? _mapAuthExceptionCodeToBlocError(
    AuthExceptionCode authExceptionCode,
  ) {
    if (authExceptionCode == AuthExceptionCode.emailAlreadyInUse) {
      return SignUpBlocError.emailAlreadyInUse;
    }
    return null;
  }
}

enum SignUpBlocInfo {
  signedUp,
}

enum SignUpBlocError {
  emailAlreadyInUse,
}
