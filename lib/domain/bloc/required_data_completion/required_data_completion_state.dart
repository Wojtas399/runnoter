part of 'required_data_completion_bloc.dart';

class RequiredDataCompletionState
    extends BlocState<RequiredDataCompletionState> {
  final AccountType accountType;
  final Gender gender;
  final String name;
  final String surname;

  const RequiredDataCompletionState({
    super.status = const BlocStatusInitial(),
    this.accountType = AccountType.runner,
    this.gender = Gender.male,
    this.name = '',
    this.surname = '',
  });

  @override
  List<Object?> get props => [accountType, status, gender, name, surname];

  bool get isNameValid => validator.isNameOrSurnameValid(name);

  bool get isSurnameValid => validator.isNameOrSurnameValid(surname);

  bool get canSubmit => isNameValid && isSurnameValid;

  @override
  RequiredDataCompletionState copyWith({
    BlocStatus? status,
    AccountType? accountType,
    Gender? gender,
    String? name,
    String? surname,
  }) =>
      RequiredDataCompletionState(
        status: status ?? const BlocStatusComplete(),
        accountType: accountType ?? this.accountType,
        gender: gender ?? this.gender,
        name: name ?? this.name,
        surname: surname ?? this.surname,
      );
}
