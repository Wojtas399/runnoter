import '../../../../domain/model/blood_reading.dart';
import '../../../model/bloc_state.dart';
import '../../../model/bloc_status.dart';

class BloodReadingPreviewState extends BlocState<BloodReadingPreviewState> {
  final DateTime? date;
  final List<BloodReadingParameter>? readParameters;

  const BloodReadingPreviewState({
    required super.status,
    this.date,
    this.readParameters,
  });

  @override
  List<Object?> get props => [
        status,
        date,
        readParameters,
      ];

  @override
  BloodReadingPreviewState copyWith({
    BlocStatus? status,
    DateTime? date,
    List<BloodReadingParameter>? readParameters,
  }) =>
      BloodReadingPreviewState(
        status: status ?? const BlocStatusComplete(),
        date: date ?? this.date,
        readParameters: readParameters ?? this.readParameters,
      );
}
