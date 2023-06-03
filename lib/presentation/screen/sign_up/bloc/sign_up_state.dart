import '../../../../domain/additional_model/bloc_state.dart';
import '../../../../domain/additional_model/bloc_status.dart';
import '../../../service/validation_service.dart' as validator;

enum SignUpInfo {
  signedUp,
}

enum SignUpError {
  emailAlreadyInUse,
}

class SignUpState extends BlocState {
  final String name;
  final String surname;
  final String email;
  final String password;
  final String passwordConfirmation;

  const SignUpState({
    required super.status,
    required this.name,
    required this.surname,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  @override
  List<Object> get props => [
        status,
        name,
        surname,
        email,
        password,
        passwordConfirmation,
      ];

  bool get isNameValid => validator.isNameOrSurnameValid(name);

  bool get isSurnameValid => validator.isNameOrSurnameValid(surname);

  bool get isEmailValid => validator.isEmailValid(email);

  bool get isPasswordValid => validator.isPasswordValid(password);

  bool get isPasswordConfirmationValid => password == passwordConfirmation;

  bool get isSubmitButtonDisabled => !_areAllParamsValid();

  @override
  SignUpState copyWith({
    BlocStatus? status,
    String? name,
    String? surname,
    String? email,
    String? password,
    String? passwordConfirmation,
  }) {
    return SignUpState(
      status: status ?? const BlocStatusComplete(),
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
    );
  }

  bool _areAllParamsValid() {
    return isNameValid &&
        isSurnameValid &&
        isEmailValid &&
        isPasswordValid &&
        isPasswordConfirmationValid;
  }
}
