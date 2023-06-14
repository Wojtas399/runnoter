import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../entity/run_status.dart';
import '../../entity/workout.dart';
import '../../repository/workout_repository.dart';
import '../../service/auth_service.dart';

class MileageCubit extends Cubit<List<ChartYear>?> {
  final AuthService _authService;
  final WorkoutRepository _workoutRepository;
  StreamSubscription<List<Workout>?>? _workoutListener;

  MileageCubit({
    required AuthService authService,
    required WorkoutRepository workoutRepository,
  })  : _authService = authService,
        _workoutRepository = workoutRepository,
        super(null);

  @override
  Future<void> close() {
    _workoutListener?.cancel();
    _workoutListener = null;
    return super.close();
  }

  void initialize() {
    _workoutListener ??= _authService.loggedUserId$
        .whereType<String>()
        .switchMap(
          (loggedUserId) => _workoutRepository.getAllWorkouts(
            userId: loggedUserId,
          ),
        )
        .listen(_emitChartPoints);
  }

  void _emitChartPoints(List<Workout>? workouts) {
    if (workouts == null) {
      return;
    }
    final List<Workout> sortedWorkouts = _sortWorkoutsByDate(workouts);
    if (sortedWorkouts.isEmpty) {
      emit([]);
      return;
    }
    final int lastYear = sortedWorkouts.last.date.year;
    int yearCounter = sortedWorkouts.first.date.year;
    final List<ChartYear> years = [];
    while (yearCounter <= lastYear) {
      final List<ChartMonth> months =
          _createMonthsForYear(yearCounter, workouts);
      years.add(ChartYear(
        year: yearCounter,
        months: months,
      ));
      yearCounter++;
    }
    emit(years);
  }

  List<Workout> _sortWorkoutsByDate(List<Workout> workouts) {
    final List<Workout> sortedWorkouts = [...workouts];
    sortedWorkouts.sort(
      (workout1, workout2) => workout1.date.compareTo(workout2.date),
    );
    return sortedWorkouts;
  }

  List<ChartMonth> _createMonthsForYear(int year, List<Workout> workouts) {
    final List<ChartMonth> months = [];
    for (int month = 1; month <= 12; month++) {
      final Iterable<Workout> workoutsFromMonth = workouts.where(
        (workout) => workout.date.year == year && workout.date.month == month,
      );
      double mileage = 0.0;
      if (workoutsFromMonth.isNotEmpty) {
        mileage = workoutsFromMonth.map(_calculateWorkoutDistance).reduce(
              (totalDistance, workoutDistance) =>
                  totalDistance + workoutDistance,
            );
      }
      months.add(ChartMonth(
        month: Month.values[month - 1],
        mileage: mileage,
      ));
    }
    return months;
  }

  double _calculateWorkoutDistance(Workout workout) {
    final RunStatus status = workout.status;
    if (status is RunStatusWithParams) {
      return status.coveredDistanceInKm;
    }
    return 0.0;
  }
}

class ChartYear extends Equatable {
  final int year;
  final List<ChartMonth> months;

  const ChartYear({
    required this.year,
    required this.months,
  });

  @override
  List<Object?> get props => [
        year,
        months,
      ];
}

class ChartMonth extends Equatable {
  final Month month;
  final double mileage;

  const ChartMonth({
    required this.month,
    required this.mileage,
  });

  @override
  List<Object?> get props => [
        month,
        mileage,
      ];
}

enum Month {
  january(1),
  february(2),
  march(3),
  april(4),
  may(5),
  june(6),
  july(7),
  august(8),
  september(9),
  october(10),
  november(11),
  december(12);

  final int monthNumber;

  const Month(this.monthNumber);
}
