part of 'calendar_bloc.dart';

class CalendarState extends BlocState<CalendarState> {
  final List<Workout>? workouts;

  const CalendarState({
    required super.status,
    required this.workouts,
  });

  @override
  List<Object?> get props => [
        status,
        workouts,
      ];

  @override
  CalendarState copyWith({
    BlocStatus? status,
    List<Workout>? workouts,
  }) =>
      CalendarState(
        status: status ?? const BlocStatusComplete(),
        workouts: workouts ?? this.workouts,
      );
}
