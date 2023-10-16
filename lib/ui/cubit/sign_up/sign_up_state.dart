part of 'sign_up_cubit.dart';

class SignUpState extends CubitState<SignUpState> {
  final AccountType accountType;
  final Gender gender;
  final String name;
  final String surname;
  final String email;
  final DateTime? dateOfBirth;
  final String password;
  final String passwordConfirmation;

  const SignUpState({
    required super.status,
    this.accountType = AccountType.runner,
    this.gender = Gender.male,
    this.name = '',
    this.surname = '',
    this.email = '',
    this.dateOfBirth,
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
        dateOfBirth,
        password,
        passwordConfirmation,
      ];

  bool get isNameValid => validator.isNameOrSurnameValid(name);

  bool get isSurnameValid => validator.isNameOrSurnameValid(surname);

  bool get isEmailValid => validator.isEmailValid(email);

  bool get isPasswordValid => validator.isPasswordValid(password);

  bool get isPasswordConfirmationValid => password == passwordConfirmation;

  bool get canSubmit => _areAllParamsValid();

  @override
  SignUpState copyWith({
    CubitStatus? status,
    AccountType? accountType,
    Gender? gender,
    String? name,
    String? surname,
    String? email,
    DateTime? dateOfBirth,
    String? password,
    String? passwordConfirmation,
  }) {
    return SignUpState(
      status: status ?? const CubitStatusComplete(),
      accountType: accountType ?? this.accountType,
      gender: gender ?? this.gender,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
    );
  }

  bool _areAllParamsValid() =>
      isNameValid &&
      isSurnameValid &&
      isEmailValid &&
      dateOfBirth != null &&
      isPasswordValid &&
      isPasswordConfirmationValid;
}
