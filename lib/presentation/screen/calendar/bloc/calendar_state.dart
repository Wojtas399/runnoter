part of 'calendar_bloc.dart';

class CalendarState extends BlocState<CalendarState> {
  final List<Workout>? workouts;
  final int? month;
  final int? year;

  const CalendarState({
    required super.status,
    required this.workouts,
    required this.month,
    required this.year,
  });

  @override
  List<Object?> get props => [
        status,
        workouts,
        month,
        year,
      ];

  @override
  CalendarState copyWith({
    BlocStatus? status,
    List<Workout>? workouts,
    int? month,
    int? year,
  }) =>
      CalendarState(
        status: status ?? const BlocStatusComplete(),
        workouts: workouts ?? this.workouts,
        month: month ?? this.month,
        year: year ?? this.year,
      );
}
