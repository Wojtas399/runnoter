import '../../../presentation/service/validation_service.dart' as validator;
import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../entity/user.dart';

class RequiredDataCompletionState
    extends BlocState<RequiredDataCompletionState> {
  final Gender gender;
  final String name;
  final String surname;

  const RequiredDataCompletionState({
    required super.status,
    this.gender = Gender.male,
    this.name = '',
    this.surname = '',
  });

  @override
  List<Object?> get props => [status, gender, name, surname];

  bool get isNameValid => validator.isNameOrSurnameValid(name);

  bool get isSurnameValid => validator.isNameOrSurnameValid(surname);

  bool get canSubmit => isNameValid && isSurnameValid;

  @override
  RequiredDataCompletionState copyWith({
    BlocStatus? status,
    Gender? gender,
    String? name,
    String? surname,
  }) =>
      RequiredDataCompletionState(
        status: status ?? const BlocStatusComplete(),
        gender: gender ?? this.gender,
        name: name ?? this.name,
        surname: surname ?? this.surname,
      );
}
