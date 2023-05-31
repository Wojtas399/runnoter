import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/model/blood_reading.dart';
import '../../../../domain/repository/blood_reading_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../model/bloc_state.dart';
import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';

part 'blood_reading_preview_event.dart';
part 'blood_reading_preview_state.dart';

class BloodReadingPreviewBloc extends BlocWithStatus<BloodReadingPreviewEvent,
    BloodReadingPreviewState, BloodReadingPreviewBlocInfo, dynamic> {
  final AuthService _authService;
  final BloodReadingRepository _bloodReadingRepository;
  StreamSubscription<BloodReading?>? _bloodReadingListener;

  BloodReadingPreviewBloc({
    required AuthService authService,
    required BloodReadingRepository bloodReadingRepository,
    BloodReadingPreviewState state = const BloodReadingPreviewState(
      status: BlocStatusInitial(),
    ),
  })  : _authService = authService,
        _bloodReadingRepository = bloodReadingRepository,
        super(state) {
    on<BloodReadingPreviewEventInitialize>(_initialize);
    on<BloodReadingPreviewEventBloodReadingUpdated>(_bloodReadingUpdated);
    on<BloodReadingPreviewEventDeleteReading>(_deleteReading);
  }

  @override
  Future<void> close() {
    _bloodReadingListener?.cancel();
    _bloodReadingListener = null;
    return super.close();
  }

  void _initialize(
    BloodReadingPreviewEventInitialize event,
    Emitter<BloodReadingPreviewState> emit,
  ) {
    _bloodReadingListener ??= _authService.loggedUserId$
        .whereNotNull()
        .switchMap(
          (String loggedUserId) => _bloodReadingRepository.getReadingById(
            bloodReadingId: event.bloodReadingId,
            userId: loggedUserId,
          ),
        )
        .listen(
          (BloodReading? bloodReading) => add(
            BloodReadingPreviewEventBloodReadingUpdated(
              bloodReading: bloodReading,
            ),
          ),
        );
  }

  void _bloodReadingUpdated(
    BloodReadingPreviewEventBloodReadingUpdated event,
    Emitter<BloodReadingPreviewState> emit,
  ) {
    emit(state.copyWith(
      bloodReadingId: event.bloodReading?.id,
      date: event.bloodReading?.date,
      readParameters: event.bloodReading?.parameters,
    ));
  }

  Future<void> _deleteReading(
    BloodReadingPreviewEventDeleteReading event,
    Emitter<BloodReadingPreviewState> emit,
  ) async {
    if (state.bloodReadingId == null) {
      return;
    }
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
    await _bloodReadingRepository.deleteReading(
      bloodReadingId: state.bloodReadingId!,
      userId: loggedUserId,
    );
    emitCompleteStatus(
      emit,
      BloodReadingPreviewBlocInfo.bloodReadingDeleted,
    );
  }
}

enum BloodReadingPreviewBlocInfo {
  bloodReadingDeleted,
}
