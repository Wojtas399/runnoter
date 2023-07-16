import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/entity/blood_parameter.dart';
import '../../../../domain/entity/blood_test.dart';
import '../../../../domain/repository/blood_test_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/bloc_with_status.dart';

part 'blood_test_preview_event.dart';
part 'blood_test_preview_state.dart';

class BloodTestPreviewBloc extends BlocWithStatus<BloodTestPreviewEvent,
    BloodTestPreviewState, BloodTestPreviewBlocInfo, dynamic> {
  final AuthService _authService;
  final BloodTestRepository _bloodTestRepository;
  final String? bloodTestId;

  BloodTestPreviewBloc({
    required AuthService authService,
    required BloodTestRepository bloodTestRepository,
    required this.bloodTestId,
    BloodTestPreviewState state = const BloodTestPreviewState(
      status: BlocStatusInitial(),
    ),
  })  : _authService = authService,
        _bloodTestRepository = bloodTestRepository,
        super(state) {
    on<BloodTestPreviewEventInitialize>(
      _initialize,
      transformer: restartable(),
    );
    on<BloodTestPreviewEventDeleteTest>(_deleteTest);
  }

  Future<void> _initialize(
    BloodTestPreviewEventInitialize event,
    Emitter<BloodTestPreviewState> emit,
  ) async {
    if (bloodTestId == null) return;
    final Stream<BloodTest?> bloodTest$ =
        _authService.loggedUserId$.whereNotNull().switchMap(
              (String loggedUserId) => _bloodTestRepository.getTestById(
                bloodTestId: bloodTestId!,
                userId: loggedUserId,
              ),
            );
    await emit.forEach(
      bloodTest$,
      onData: (BloodTest? bloodTest) => state.copyWith(
        date: bloodTest?.date,
        parameterResults: bloodTest?.parameterResults,
      ),
    );
  }

  Future<void> _deleteTest(
    BloodTestPreviewEventDeleteTest event,
    Emitter<BloodTestPreviewState> emit,
  ) async {
    if (bloodTestId == null) return;
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
    await _bloodTestRepository.deleteTest(
      bloodTestId: bloodTestId!,
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
