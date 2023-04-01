import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/model/auth_exception.dart';
import '../../../../domain/model/settings.dart';
import '../../../../domain/model/user.dart';
import '../../../../domain/repository/user_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';
import '../../../service/connectivity_service.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc
    extends BlocWithStatus<SignUpEvent, SignUpState, SignUpInfo, SignUpError> {
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
      emitCompleteStatus(emit, SignUpInfo.signedUp);
    } on AuthException catch (authException) {
      final SignUpError? error = _mapAuthExceptionToBlocError(authException);
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

  SignUpError? _mapAuthExceptionToBlocError(AuthException exception) {
    if (exception == AuthException.emailAlreadyInUse) {
      return SignUpError.emailAlreadyInUse;
    }
    return null;
  }
}
