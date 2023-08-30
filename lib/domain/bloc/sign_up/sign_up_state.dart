part of 'sign_up_bloc.dart';

class SignUpState extends BlocState {
  final AccountType accountType;
  final Gender gender;
  final String name;
  final String surname;
  final String email;
  final String password;
  final String passwordConfirmation;

  const SignUpState({
    required super.status,
    this.accountType = AccountType.runner,
    this.gender = Gender.male,
    this.name = '',
    this.surname = '',
    this.email = '',
    this.password = '',
    this.passwordConfirmation = '',
  });

  @override
  List<Object?> get props => [
        status,
        accountType,
        gender,
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
    AccountType? accountType,
    Gender? gender,
    String? name,
    String? surname,
    String? email,
    String? password,
    String? passwordConfirmation,
  }) {
    return SignUpState(
      status: status ?? const BlocStatusComplete(),
      accountType: accountType ?? this.accountType,
      gender: gender ?? this.gender,
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
