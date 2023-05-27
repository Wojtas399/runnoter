import '../../../../domain/model/blood_reading.dart';
import '../../../model/bloc_state.dart';
import '../../../model/bloc_status.dart';

class BloodReadingCreatorState extends BlocState<BloodReadingCreatorState> {
  final DateTime? date;
  final List<BloodReadingParameter>? parameters;

  const BloodReadingCreatorState({
    required super.status,
    this.date,
    this.parameters,
  });

  @override
  List<Object?> get props => [
        status,
        date,
        parameters,
      ];

  bool get isSubmitButtonDisabled =>
      date == null || parameters == null || parameters?.isEmpty == true;

  @override
  BloodReadingCreatorState copyWith({
    BlocStatus? status,
    DateTime? date,
    List<BloodReadingParameter>? parameters,
  }) =>
      BloodReadingCreatorState(
        status: status ?? const BlocStatusComplete(),
        date: date ?? this.date,
        parameters: parameters ?? this.parameters,
      );
}
