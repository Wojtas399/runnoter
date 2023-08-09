import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/entity/blood_test.dart';
import '../../../../domain/repository/blood_test_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../dependency_injection.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/bloc_with_status.dart';
import '../../additional_model/blood_parameter.dart';
import '../../entity/user.dart';
import '../../use_case/get_logged_user_gender_use_case.dart';

part 'blood_test_preview_event.dart';
part 'blood_test_preview_state.dart';

class BloodTestPreviewBloc extends BlocWithStatus<BloodTestPreviewEvent,
    BloodTestPreviewState, BloodTestPreviewBlocInfo, dynamic> {
  final AuthService _authService;
  final GetLoggedUserGenderUseCase _getLoggedUserGenderUseCase;
  final BloodTestRepository _bloodTestRepository;
  final String? bloodTestId;

  BloodTestPreviewBloc({
    required this.bloodTestId,
    BloodTestPreviewState state = const BloodTestPreviewState(
      status: BlocStatusInitial(),
    ),
  })  : _authService = getIt<AuthService>(),
        _getLoggedUserGenderUseCase = getIt<GetLoggedUserGenderUseCase>(),
        _bloodTestRepository = getIt<BloodTestRepository>(),
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
    final Stream<(Gender, BloodTest?)> stream$ = Rx.combineLatest2(
      _getLoggedUserGenderUseCase.execute(),
      _getBloodTest(),
      (Gender gender, BloodTest? bloodTest) => (gender, bloodTest),
    );
    await emit.forEach(
      stream$,
      onData: ((Gender, BloodTest?) params) => state.copyWith(
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
      info: BloodTestPreviewBlocInfo.bloodTestDeleted,
    );
  }

  Stream<BloodTest?> _getBloodTest() =>
      _authService.loggedUserId$.whereNotNull().switchMap(
            (String loggedUserId) => _bloodTestRepository.getTestById(
              bloodTestId: bloodTestId!,
              userId: loggedUserId,
            ),
          );
}

enum BloodTestPreviewBlocInfo {
  bloodTestDeleted,
}
