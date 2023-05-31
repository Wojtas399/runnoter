part of 'blood_reading_preview_bloc.dart';

class BloodReadingPreviewState extends BlocState<BloodReadingPreviewState> {
  final String? bloodReadingId;
  final DateTime? date;
  final List<BloodReadingParameter>? readParameters;

  const BloodReadingPreviewState({
    required super.status,
    this.bloodReadingId,
    this.date,
    this.readParameters,
  });

  @override
  List<Object?> get props => [
        status,
        bloodReadingId,
        date,
        readParameters,
      ];

  @override
  BloodReadingPreviewState copyWith({
    BlocStatus? status,
    String? bloodReadingId,
    DateTime? date,
    List<BloodReadingParameter>? readParameters,
  }) =>
      BloodReadingPreviewState(
        status: status ?? const BlocStatusComplete(),
        bloodReadingId: bloodReadingId ?? this.bloodReadingId,
        date: date ?? this.date,
        readParameters: readParameters ?? this.readParameters,
      );
}
