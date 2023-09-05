part of 'required_data_completion_cubit.dart';

class RequiredDataCompletionState
    extends CubitState<RequiredDataCompletionState> {
  final AccountType accountType;
  final Gender gender;
  final String name;
  final String surname;
  final DateTime? dateOfBirth;

  const RequiredDataCompletionState({
    super.status = const BlocStatusInitial(),
    this.accountType = AccountType.runner,
    this.gender = Gender.male,
    this.name = '',
    this.surname = '',
    this.dateOfBirth,
  });

  @override
  List<Object?> get props => [status, accountType, gender, name, surname];

  bool get isNameValid => validator.isNameOrSurnameValid(name);

  bool get isSurnameValid => validator.isNameOrSurnameValid(surname);

  bool get canSubmit => isNameValid && isSurnameValid && dateOfBirth != null;

  @override
  RequiredDataCompletionState copyWith({
    BlocStatus? status,
    AccountType? accountType,
    Gender? gender,
    String? name,
    String? surname,
    DateTime? dateOfBirth,
  }) =>
      RequiredDataCompletionState(
        status: status ?? const BlocStatusComplete(),
        accountType: accountType ?? this.accountType,
        gender: gender ?? this.gender,
        name: name ?? this.name,
        surname: surname ?? this.surname,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      );
}
