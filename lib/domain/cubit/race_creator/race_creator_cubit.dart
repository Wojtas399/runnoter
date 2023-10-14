import '../../../data/additional_model/activity_status.dart';
import '../../../data/additional_model/custom_exception.dart';
import '../../../data/entity/race.dart';
import '../../../data/interface/repository/race_repository.dart';
import '../../../dependency_injection.dart';
import '../../additional_model/cubit_state.dart';
import '../../additional_model/cubit_status.dart';
import '../../additional_model/cubit_with_status.dart';

part 'race_creator_state.dart';

class RaceCreatorCubit extends CubitWithStatus<RaceCreatorState,
    RaceCreatorCubitInfo, RaceCreatorCubitError> {
  final String _userId;
  final String? raceId;
  final RaceRepository _raceRepository;

  RaceCreatorCubit({
    required String userId,
    this.raceId,
    RaceCreatorState initialState = const RaceCreatorState(
      status: CubitStatusInitial(),
    ),
  })  : _userId = userId,
        _raceRepository = getIt<RaceRepository>(),
        super(initialState);

  Future<void> initialize(DateTime? date) async {
    if (raceId == null) {
      emit(state.copyWith(date: date));
      return;
    }
    final Stream<Race?> race$ = _raceRepository.getRaceById(
      raceId: raceId!,
      userId: _userId,
    );
    await for (final race in race$) {
      emit(state.copyWith(
        status: const CubitStatusComplete<RaceCreatorCubitInfo>(),
        race: race,
        name: race?.name,
        date: race?.date,
        place: race?.place,
        distance: race?.distance,
        expectedDuration: race?.expectedDuration,
      ));
      return;
    }
  }

  void nameChanged(String name) {
    emit(state.copyWith(name: name));
  }

  void dateChanged(DateTime date) {
    emit(state.copyWith(date: date));
  }

  void placeChanged(String place) {
    emit(state.copyWith(place: place));
  }

  void distanceChanged(double distance) {
    emit(state.copyWith(distance: distance));
  }

  void expectedDurationChanged(Duration expectedDuration) {
    emit(state.copyWith(expectedDuration: expectedDuration));
  }

  Future<void> submit() async {
    if (!state.canSubmit) return;
    emitLoadingStatus();
    Duration? expectedDuration = state.expectedDuration;
    if (expectedDuration != null && expectedDuration.inSeconds == 0) {
      expectedDuration = null;
    }
    if (state.race == null) {
      await _addNewRace(expectedDuration);
      emitCompleteStatus(info: RaceCreatorCubitInfo.raceAdded);
    } else {
      try {
        await _updateRace(expectedDuration);
        emitCompleteStatus(info: RaceCreatorCubitInfo.raceUpdated);
      } on EntityException catch (entityException) {
        if (entityException.code == EntityExceptionCode.entityNotFound) {
          emitErrorStatus(RaceCreatorCubitError.raceNoLongerExists);
        }
      }
    }
  }

  Future<void> _addNewRace(Duration? expectedDuration) async =>
      await _raceRepository.addNewRace(
        userId: _userId,
        name: state.name!,
        date: state.date!,
        place: state.place!,
        distance: state.distance!,
        expectedDuration: expectedDuration,
        status: const ActivityStatusPending(),
      );

  Future<void> _updateRace(Duration? expectedDuration) async =>
      await _raceRepository.updateRace(
        raceId: state.race!.id,
        userId: _userId,
        name: state.name!,
        date: state.date!,
        place: state.place!,
        distance: state.distance!,
        expectedDuration: expectedDuration,
        setDurationAsNull: expectedDuration == null,
      );
}

enum RaceCreatorCubitInfo { raceAdded, raceUpdated }

enum RaceCreatorCubitError { raceNoLongerExists }
