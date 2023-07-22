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
import '../../entity/user.dart';
import '../../repository/user_repository.dart';

part 'blood_test_preview_event.dart';
part 'blood_test_preview_state.dart';

class BloodTestPreviewBloc extends BlocWithStatus<BloodTestPreviewEvent,
    BloodTestPreviewState, BloodTestPreviewBlocInfo, dynamic> {
  final AuthService _authService;
  final UserRepository _userRepository;
  final BloodTestRepository _bloodTestRepository;
  final String? bloodTestId;

  BloodTestPreviewBloc({
    required AuthService authService,
    required UserRepository userRepository,
    required BloodTestRepository bloodTestRepository,
    required this.bloodTestId,
    BloodTestPreviewState state = const BloodTestPreviewState(
      status: BlocStatusInitial(),
    ),
  })  : _authService = authService,
        _userRepository = userRepository,
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
    final Stream<(Gender?, BloodTest?)> listenedParams$ =
        _authService.loggedUserId$.whereNotNull().switchMap(
              (String loggedUserId) => Rx.combineLatest2(
                _getLoggedUserGender(loggedUserId),
                _bloodTestRepository.getTestById(
                  bloodTestId: bloodTestId!,
                  userId: loggedUserId,
                ),
                (Gender? gender, BloodTest? bloodTest) => (gender, bloodTest),
              ),
            );
    await emit.forEach(
      listenedParams$,
      onData: ((Gender?, BloodTest?) params) => state.copyWith(
        date: params.$2?.date,
        gender: params.$1,
        parameterResults: params.$2?.parameterResults,
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

  Stream<Gender?> _getLoggedUserGender(String loggedUserId) => _userRepository
      .getUserById(userId: loggedUserId)
      .map((User? user) => user?.gender);
}

enum BloodTestPreviewBlocInfo {
  bloodTestDeleted,
}
