import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/entity/blood_test.dart';
import '../../../../domain/repository/blood_test_repository.dart';
import '../../../dependency_injection.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/bloc_with_status.dart';
import '../../additional_model/blood_parameter.dart';
import '../../entity/user.dart';
import '../../repository/user_repository.dart';

part 'blood_test_preview_event.dart';
part 'blood_test_preview_state.dart';

class BloodTestPreviewBloc extends BlocWithStatus<BloodTestPreviewEvent,
    BloodTestPreviewState, BloodTestPreviewBlocInfo, dynamic> {
  final UserRepository _userRepository;
  final BloodTestRepository _bloodTestRepository;
  final String userId;
  final String bloodTestId;

  BloodTestPreviewBloc({
    required this.userId,
    required this.bloodTestId,
    BloodTestPreviewState state = const BloodTestPreviewState(
      status: BlocStatusInitial(),
    ),
  })  : _userRepository = getIt<UserRepository>(),
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
    final Stream<(Gender, BloodTest?)> stream$ = Rx.combineLatest2(
      _userRepository
          .getUserById(userId: userId)
          .whereNotNull()
          .map((User user) => user.gender),
      _bloodTestRepository.getTestById(
        bloodTestId: bloodTestId,
        userId: userId,
      ),
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
    emitLoadingStatus(emit);
    await _bloodTestRepository.deleteTest(
      bloodTestId: bloodTestId,
      userId: userId,
    );
    emitCompleteStatus(
      emit,
      info: BloodTestPreviewBlocInfo.bloodTestDeleted,
    );
  }
}

enum BloodTestPreviewBlocInfo { bloodTestDeleted }
