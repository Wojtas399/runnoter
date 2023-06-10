import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/additional_model/auth_exception.dart';
import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/entity/settings.dart';
import '../../../../domain/entity/user.dart';
import '../../../../domain/repository/user_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../../domain/service/connectivity_service.dart';
import '../../../presentation/service/validation_service.dart' as validator;
import '../../additional_model/bloc_state.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends BlocWithStatus<SignUpEvent, SignUpState,
    SignUpBlocInfo, SignUpBlocError> {
  final AuthService _authService;
  final UserRepository _userRepository;
  final ConnectivityService _connectivityService;

  SignUpBloc({
    required AuthService authService,
    required UserRepository userRepository,
    required ConnectivityService connectivityService,
    BlocStatus status = const BlocStatusInitial(),
    String name = '',
    String surname = '',
    String email = '',
    String password = '',
    String passwordConfirmation = '',
  })  : _authService = authService,
        _userRepository = userRepository,
        _connectivityService = connectivityService,
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
    if (await _connectivityService.hasDeviceInternetConnection() == false) {
      emitNoInternetConnectionStatus(emit);
      return;
    }
    try {
      await _tryToSignUp();
      emitCompleteStatus(emit, SignUpBlocInfo.signedUp);
    } on AuthException catch (authException) {
      final SignUpBlocError? error =
          _mapAuthExceptionToBlocError(authException);
      if (error != null) {
        emitErrorStatus(emit, error);
      } else {
        emitUnknownErrorStatus(emit);
        rethrow;
      }
    } catch (_) {
      emitUnknownErrorStatus(emit);
      rethrow;
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
          themeMode: ThemeMode.light,
          language: Language.polish,
          distanceUnit: DistanceUnit.kilometers,
          paceUnit: PaceUnit.minutesPerKilometer,
        ),
      ),
    );
  }

  SignUpBlocError? _mapAuthExceptionToBlocError(AuthException exception) {
    if (exception == AuthException.emailAlreadyInUse) {
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
