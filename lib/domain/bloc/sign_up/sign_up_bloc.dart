import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/entity/user.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../dependency_injection.dart';
import '../../../presentation/service/validation_service.dart' as validator;
import '../../additional_model/bloc_state.dart';
import '../../additional_model/custom_exception.dart';
import '../../use_case/add_user_data_use_case.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends BlocWithStatus<SignUpEvent, SignUpState,
    SignUpBlocInfo, SignUpBlocError> {
  final AuthService _authService;
  final AddUserDataUseCase _addUserDataUseCase;

  SignUpBloc({
    SignUpState state = const SignUpState(status: BlocStatusInitial()),
  })  : _authService = getIt<AuthService>(),
        _addUserDataUseCase = getIt<AddUserDataUseCase>(),
        super(state) {
    on<SignUpEventAccountTypeChanged>(_accountTypeChanged);
    on<SignUpEventGenderChanged>(_genderChanged);
    on<SignUpEventNameChanged>(_nameChanged);
    on<SignUpEventSurnameChanged>(_surnameChanged);
    on<SignUpEventEmailChanged>(_emailChanged);
    on<SignUpEventPasswordChanged>(_passwordChanged);
    on<SignUpEventPasswordConfirmationChanged>(_passwordConfirmationChanged);
    on<SignUpEventSubmit>(_submit);
  }

  void _accountTypeChanged(
    SignUpEventAccountTypeChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(
      accountType: event.accountType,
    ));
  }

  void _genderChanged(
    SignUpEventGenderChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(
      gender: event.gender,
    ));
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
    if (state.isSubmitButtonDisabled) return;
    emitLoadingStatus(emit);
    try {
      await _tryToSignUp();
      await _authService.sendEmailVerification();
      emitCompleteStatus(emit, info: SignUpBlocInfo.signedUp);
    } on AuthException catch (authException) {
      if (authException.code == AuthExceptionCode.emailAlreadyInUse) {
        emitErrorStatus(emit, SignUpBlocError.emailAlreadyInUse);
      } else {
        emitUnknownErrorStatus(emit);
        rethrow;
      }
    } on NetworkException catch (networkException) {
      if (networkException.code == NetworkExceptionCode.requestFailed) {
        emitNoInternetConnectionStatus(emit);
      }
    } on UnknownException catch (_) {
      emitUnknownErrorStatus(emit);
      rethrow;
    }
  }

  Future<void> _tryToSignUp() async {
    final String? userId = await _authService.signUp(
      email: state.email,
      password: state.password,
    );
    if (userId == null) return;
    await _addUserDataUseCase.execute(
      accountType: state.accountType,
      userId: userId,
      gender: state.gender,
      name: state.name,
      surname: state.surname,
      email: state.email,
    );
  }
}

enum SignUpBlocInfo { signedUp }

enum SignUpBlocError { emailAlreadyInUse }
