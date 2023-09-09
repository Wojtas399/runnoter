part of 'blood_test_creator_cubit.dart';

class BloodTestCreatorState extends CubitState<BloodTestCreatorState> {
  final Gender? gender;
  final BloodTest? bloodTest;
  final DateTime? date;
  final List<BloodParameterResult>? parameterResults;

  const BloodTestCreatorState({
    required super.status,
    this.gender,
    this.bloodTest,
    this.date,
    this.parameterResults,
  });

  @override
  List<Object?> get props => [
        status,
        gender,
        bloodTest,
        date,
        parameterResults,
      ];

  bool get canSubmit =>
      gender != null &&
      date != null &&
      parameterResults != null &&
      parameterResults?.isEmpty == false &&
      (date != bloodTest?.date || _areParameterResultsNotSameAsOriginal);

  bool get _areParameterResultsNotSameAsOriginal {
    if (parameterResults == null || bloodTest?.parameterResults == null) {
      return true;
    }
    final bool areParamsTheSame = areListsEqual(
      parameterResults!,
      bloodTest!.parameterResults,
    );
    return !areParamsTheSame;
  }

  @override
  BloodTestCreatorState copyWith({
    BlocStatus? status,
    Gender? gender,
    BloodTest? bloodTest,
    DateTime? date,
    List<BloodParameterResult>? parameterResults,
  }) =>
      BloodTestCreatorState(
        status: status ?? const BlocStatusComplete(),
        gender: gender ?? this.gender,
        bloodTest: bloodTest ?? this.bloodTest,
        date: date ?? this.date,
        parameterResults: parameterResults ?? this.parameterResults,
      );
}
