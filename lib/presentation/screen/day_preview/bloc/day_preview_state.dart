import '../../../model/bloc_state.dart';
import '../../../model/bloc_status.dart';

class DayPreviewState extends BlocState<DayPreviewState> {
  final DateTime date;

  const DayPreviewState({
    required super.status,
    required this.date,
  });

  @override
  List<Object> get props => [
        status,
        date,
      ];

  @override
  DayPreviewState copyWith({
    BlocStatus? status,
    DateTime? date,
  }) {
    return DayPreviewState(
      status: status ?? const BlocStatusComplete(),
      date: date ?? this.date,
    );
  }
}
