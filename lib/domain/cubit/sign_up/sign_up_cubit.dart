import '../../../../domain/additional_model/cubit_status.dart';
import '../../../data/additional_model/custom_exception.dart';
import '../../../data/entity/user.dart';
import '../../../data/interface/service/auth_service.dart';
import '../../../dependency_injection.dart';
import '../../../presentation/service/validation_service.dart' as validator;
import '../../additional_model/cubit_state.dart';
import '../../additional_model/cubit_with_status.dart';
import '../../use_case/add_user_data_use_case.dart';

part 'sign_up_state.dart';

class SignUpCubit
    extends CubitWithStatus<SignUpState, SignUpCubitInfo, SignUpCubitError> {
  final AuthService _authService;
  final AddUserDataUseCase _addUserDataUseCase;

  SignUpCubit({
    SignUpState initialState = const SignUpState(status: CubitStatusInitial()),
  })  : _authService = getIt<AuthService>(),
        _addUserDataUseCase = getIt<AddUserDataUseCase>(),
        super(initialState);

  void accountTypeChanged(AccountType accountType) {
    emit(state.copyWith(accountType: accountType));
  }

  void genderChanged(Gender gender) {
    emit(state.copyWith(gender: gender));
  }

  void nameChanged(String name) {
    emit(state.copyWith(name: name));
  }

  void surnameChanged(String surname) {
    emit(state.copyWith(surname: surname));
  }

  void emailChanged(String email) {
    emit(state.copyWith(email: email));
  }

  void dateOfBirthChanged(DateTime dateOfBirth) {
    emit(state.copyWith(dateOfBirth: dateOfBirth));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(password: password));
  }

  void passwordConfirmationChanged(String passwordConfirmation) {
    emit(state.copyWith(passwordConfirmation: passwordConfirmation));
  }

  Future<void> submit() async {
    if (!state.canSubmit) return;
    emitLoadingStatus();
    try {
      await _tryToSignUp();
      await _authService.sendEmailVerification();
      emitCompleteStatus(info: SignUpCubitInfo.signedUp);
    } on AuthException catch (authException) {
      if (authException.code == AuthExceptionCode.emailAlreadyInUse) {
        emitErrorStatus(SignUpCubitError.emailAlreadyInUse);
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
      dateOfBirth: state.dateOfBirth!,
    );
  }
}

enum SignUpCubitInfo { signedUp }

enum SignUpCubitError { emailAlreadyInUse }
