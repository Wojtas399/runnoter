part of 'blood_test_creator_bloc.dart';

class BloodTestCreatorState extends BlocState<BloodTestCreatorState> {
  final BloodTest? bloodTest;
  final DateTime? date;
  final List<BloodParameterResult>? parameterResults;

  const BloodTestCreatorState({
    required super.status,
    this.bloodTest,
    this.date,
    this.parameterResults,
  });

  @override
  List<Object?> get props => [
        status,
        bloodTest,
        date,
        parameterResults,
      ];

  bool get canSubmit =>
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
    BloodTest? bloodTest,
    DateTime? date,
    List<BloodParameterResult>? parameterResults,
  }) =>
      BloodTestCreatorState(
        status: status ?? const BlocStatusComplete(),
        bloodTest: bloodTest ?? this.bloodTest,
        date: date ?? this.date,
        parameterResults: parameterResults ?? this.parameterResults,
      );
}
