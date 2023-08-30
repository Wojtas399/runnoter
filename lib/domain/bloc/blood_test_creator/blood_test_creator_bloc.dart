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
import '../../service/list_service.dart';

part 'blood_test_creator_event.dart';
part 'blood_test_creator_state.dart';

class BloodTestCreatorBloc extends BlocWithStatus<BloodTestCreatorEvent,
    BloodTestCreatorState, BloodTestCreatorBlocInfo, dynamic> {
  final UserRepository _userRepository;
  final BloodTestRepository _bloodTestRepository;
  final String userId;
  final String? bloodTestId;

  BloodTestCreatorBloc({
    required this.userId,
    this.bloodTestId,
    BloodTestCreatorState state = const BloodTestCreatorState(
      status: BlocStatusInitial(),
    ),
  })  : _userRepository = getIt.get<UserRepository>(),
        _bloodTestRepository = getIt<BloodTestRepository>(),
        super(state) {
    on<BloodTestCreatorEventInitialize>(_initialize);
    on<BloodTestCreatorEventDateChanged>(_dateChanged);
    on<BloodTestCreatorEventParameterResultChanged>(_parameterValueChanged);
    on<BloodTestCreatorEventSubmit>(_submit);
  }

  Future<void> _initialize(
    BloodTestCreatorEventInitialize event,
    Emitter<BloodTestCreatorState> emit,
  ) async {
    if (bloodTestId == null) {
      await for (final gender in _getUserGender()) {
        emit(state.copyWith(
          gender: gender,
        ));
        return;
      }
    }
    final Stream<(Gender, BloodTest?)> stream$ = Rx.combineLatest2(
      _getUserGender(),
      _bloodTestRepository.getTestById(
        bloodTestId: bloodTestId!,
        userId: userId,
      ),
      (Gender gender, BloodTest? bloodTest) => (gender, bloodTest),
    );
    await for (final params in stream$) {
      final Gender gender = params.$1;
      final BloodTest? bloodTest = params.$2;
      if (bloodTest != null) {
        emit(state.copyWith(
          gender: gender,
          bloodTest: bloodTest,
          date: bloodTest.date,
          parameterResults: bloodTest.parameterResults,
        ));
      }
      return;
    }
  }

  void _dateChanged(
    BloodTestCreatorEventDateChanged event,
    Emitter<BloodTestCreatorState> emit,
  ) {
    emit(state.copyWith(
      date: event.date,
    ));
  }

  void _parameterValueChanged(
    BloodTestCreatorEventParameterResultChanged event,
    Emitter<BloodTestCreatorState> emit,
  ) {
    final int parameterIndex = _findParameterIndex(event.parameter);
    final updatedParameterResults = [...?state.parameterResults];
    BloodParameterResult? parameterResult;
    if (event.value != null) {
      parameterResult = BloodParameterResult(
        parameter: event.parameter,
        value: event.value!,
      );
    }
    if (parameterIndex >= 0) {
      if (parameterResult != null) {
        updatedParameterResults[parameterIndex] = parameterResult;
      } else {
        updatedParameterResults.removeAt(parameterIndex);
      }
    } else if (parameterResult != null) {
      updatedParameterResults.add(parameterResult);
    }
    emit(state.copyWith(
      parameterResults: updatedParameterResults,
    ));
  }

  Future<void> _submit(
    BloodTestCreatorEventSubmit event,
    Emitter<BloodTestCreatorState> emit,
  ) async {
    if (!state.canSubmit) return;
    emitLoadingStatus(emit);
    if (state.bloodTest != null) {
      await _tryToUpdateTest();
      emitCompleteStatus(emit, info: BloodTestCreatorBlocInfo.bloodTestUpdated);
    } else {
      await _tryToAddTest();
      emitCompleteStatus(emit, info: BloodTestCreatorBlocInfo.bloodTestAdded);
    }
  }

  Stream<Gender> _getUserGender() => _userRepository
      .getUserById(userId: userId)
      .whereNotNull()
      .map((User user) => user.gender);

  int _findParameterIndex(BloodParameter parameter) =>
      state.parameterResults?.indexWhere(
        (result) => result.parameter == parameter,
      ) ??
      -1;

  Future<void> _tryToUpdateTest() async {
    await _bloodTestRepository.updateTest(
      bloodTestId: state.bloodTest!.id,
      userId: userId,
      date: state.date!,
      parameterResults: state.parameterResults!,
    );
  }

  Future<void> _tryToAddTest() async {
    await _bloodTestRepository.addNewTest(
      userId: userId,
      date: state.date!,
      parameterResults: state.parameterResults!,
    );
  }
}

enum BloodTestCreatorBlocInfo { bloodTestAdded, bloodTestUpdated }
