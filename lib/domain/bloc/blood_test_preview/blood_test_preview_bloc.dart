import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/model/blood_parameter.dart';
import '../../../../domain/model/blood_test.dart';
import '../../../../domain/repository/blood_test_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../presentation/model/bloc_state.dart';
import '../../../presentation/model/bloc_status.dart';
import '../../../presentation/model/bloc_with_status.dart';

part 'blood_test_preview_event.dart';
part 'blood_test_preview_state.dart';

class BloodTestPreviewBloc extends BlocWithStatus<BloodTestPreviewEvent,
    BloodTestPreviewState, BloodTestPreviewBlocInfo, dynamic> {
  final AuthService _authService;
  final BloodTestRepository _bloodTestRepository;
  StreamSubscription<BloodTest?>? _bloodTestListener;

  BloodTestPreviewBloc({
    required AuthService authService,
    required BloodTestRepository bloodTestRepository,
    BloodTestPreviewState state = const BloodTestPreviewState(
      status: BlocStatusInitial(),
    ),
  })  : _authService = authService,
        _bloodTestRepository = bloodTestRepository,
        super(state) {
    on<BloodTestPreviewEventInitialize>(_initialize);
    on<BloodTestPreviewEventBloodTestUpdated>(_bloodTestUpdated);
    on<BloodTestPreviewEventDeleteTest>(_deleteTest);
  }

  @override
  Future<void> close() {
    _bloodTestListener?.cancel();
    _bloodTestListener = null;
    return super.close();
  }

  void _initialize(
    BloodTestPreviewEventInitialize event,
    Emitter<BloodTestPreviewState> emit,
  ) {
    _bloodTestListener ??= _authService.loggedUserId$
        .whereNotNull()
        .switchMap(
          (String loggedUserId) => _bloodTestRepository.getTestById(
            bloodTestId: event.bloodTestId,
            userId: loggedUserId,
          ),
        )
        .listen(
          (BloodTest? bloodTest) => add(
            BloodTestPreviewEventBloodTestUpdated(
              bloodTest: bloodTest,
            ),
          ),
        );
  }

  void _bloodTestUpdated(
    BloodTestPreviewEventBloodTestUpdated event,
    Emitter<BloodTestPreviewState> emit,
  ) {
    emit(state.copyWith(
      bloodTestId: event.bloodTest?.id,
      date: event.bloodTest?.date,
      parameterResults: event.bloodTest?.parameterResults,
    ));
  }

  Future<void> _deleteTest(
    BloodTestPreviewEventDeleteTest event,
    Emitter<BloodTestPreviewState> emit,
  ) async {
    if (state.bloodTestId == null) {
      return;
    }
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
    await _bloodTestRepository.deleteTest(
      bloodTestId: state.bloodTestId!,
      userId: loggedUserId,
    );
    emitCompleteStatus(
      emit,
      BloodTestPreviewBlocInfo.bloodTestDeleted,
    );
  }
}

enum BloodTestPreviewBlocInfo {
  bloodTestDeleted,
}
