import '../../../../domain/model/workout.dart';
import '../../../model/bloc_state.dart';
import '../../../model/bloc_status.dart';

class DayPreviewState extends BlocState<DayPreviewState> {
  final DateTime? date;
  final Workout? workout;

  const DayPreviewState({
    required super.status,
    required this.date,
    required this.workout,
  });

  @override
  List<Object?> get props => [
        status,
        date,
        workout,
      ];

  @override
  DayPreviewState copyWith({
    BlocStatus? status,
    DateTime? date,
    Workout? workout,
  }) {
    return DayPreviewState(
      status: status ?? const BlocStatusComplete(),
      date: date ?? this.date,
      workout: workout ?? this.workout,
    );
  }
}
