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
      date != bloodTest?.date &&
      parameterResults != null &&
      parameterResults?.isEmpty == false &&
      _areParameterResultsNotSameAsOriginal;

  bool get _areParameterResultsNotSameAsOriginal {
    if (parameterResults == null || bloodTest?.parameterResults == null) {
      return true;
    }
    for (final newParameterResult in parameterResults!) {
      bool isNew = true;
      for (final existingParameterResult in bloodTest!.parameterResults) {
        if (newParameterResult == existingParameterResult) {
          isNew = false;
        }
      }
      if (isNew == true) {
        return true;
      }
    }
    return false;
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
