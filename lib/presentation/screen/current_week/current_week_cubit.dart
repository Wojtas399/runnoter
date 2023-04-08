import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/model/workout.dart';
import '../../../domain/repository/workout_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../service/date_service.dart';

class CurrentWeekCubit extends Cubit<List<Workout>?> {
  final DateService _dateService;
  final AuthService _authService;
  final WorkoutRepository _workoutRepository;
  StreamSubscription<List<Workout>?>? _workoutsListener;

  CurrentWeekCubit({
    required DateService dateService,
    required AuthService authService,
    required WorkoutRepository workoutRepository,
  })  : _dateService = dateService,
        _authService = authService,
        _workoutRepository = workoutRepository,
        super(null);

  @override
  Future<void> close() {
    _workoutsListener?.cancel();
    _workoutsListener = null;
    return super.close();
  }

  void initialize() {
    _workoutsListener ??= _authService.loggedUserId$
        .whereType<String>()
        .switchMap(
          (String loggedUserId) => _workoutRepository.getWorkoutsFromWeek(
            userId: loggedUserId,
            dateFromWeek: _dateService.getNow(),
          ),
        )
        .listen(
      (List<Workout>? workoutsFromWeek) {
        emit(workoutsFromWeek);
      },
    );
  }
}
