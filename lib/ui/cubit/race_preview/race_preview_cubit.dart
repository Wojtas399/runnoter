import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dependency_injection.dart';
import '../../../data/model/activity.dart';
import '../../../data/model/race.dart';
import '../../../data/repository/race/race_repository.dart';

part 'race_preview_state.dart';

class RacePreviewCubit extends Cubit<RacePreviewState> {
  final RaceRepository _raceRepository;
  final String userId;
  final String raceId;
  StreamSubscription<Race?>? _raceListener;

  RacePreviewCubit({
    required this.userId,
    required this.raceId,
    RacePreviewState initialState = const RacePreviewState(),
  })  : _raceRepository = getIt<RaceRepository>(),
        super(initialState);

  @override
  Future<void> close() {
    _raceListener?.cancel();
    _raceListener = null;
    return super.close();
  }

  Future<void> initialize() async {
    _raceListener ??=
        _raceRepository.getRaceById(raceId: raceId, userId: userId).listen(
              (Race? race) => emit(state.copyWith(
                name: race?.name,
                date: race?.date,
                place: race?.place,
                distance: race?.distance,
                expectedDuration: race?.expectedDuration,
                raceStatus: race?.status,
              )),
            );
  }

  Future<void> deleteRace() async {
    await _raceRepository.deleteRace(raceId: raceId, userId: userId);
  }
}
