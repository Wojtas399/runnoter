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
import '../../service/list_service.dart';
import '../../use_case/get_logged_user_gender_use_case.dart';

part 'blood_test_creator_event.dart';
part 'blood_test_creator_state.dart';

class BloodTestCreatorBloc extends BlocWithStatus<BloodTestCreatorEvent,
    BloodTestCreatorState, BloodTestCreatorBlocInfo, dynamic> {
  final AuthService _authService;
  final GetLoggedUserGenderUseCase _getLoggedUserGenderUseCase;
  final BloodTestRepository _bloodTestRepository;
  final String? bloodTestId;

  BloodTestCreatorBloc({
    required AuthService authService,
    required GetLoggedUserGenderUseCase getLoggedUserGenderUseCase,
    required BloodTestRepository bloodTestRepository,
    required this.bloodTestId,
    BloodTestCreatorState state = const BloodTestCreatorState(
      status: BlocStatusInitial(),
    ),
  })  : _authService = authService,
        _getLoggedUserGenderUseCase = getLoggedUserGenderUseCase,
        _bloodTestRepository = bloodTestRepository,
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
      await for (final gender in _getLoggedUserGenderUseCase.execute()) {
        emit(state.copyWith(
          gender: gender,
        ));
        return;
      }
    }
    final Stream<(Gender, BloodTest?)> stream$ = Rx.combineLatest2(
      _getLoggedUserGenderUseCase.execute(),
      _getBloodTest(),
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
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
    if (state.bloodTest != null) {
      await _updateTest(loggedUserId, emit);
    } else {
      await _addTest(loggedUserId, emit);
    }
  }

  Stream<BloodTest?> _getBloodTest() =>
      _authService.loggedUserId$.whereType<String>().switchMap(
            (String loggedUserId) => _bloodTestRepository.getTestById(
              bloodTestId: bloodTestId!,
              userId: loggedUserId,
            ),
          );

  int _findParameterIndex(BloodParameter parameter) =>
      state.parameterResults?.indexWhere(
        (result) => result.parameter == parameter,
      ) ??
      -1;

  Future<void> _updateTest(
    String loggedUserId,
    Emitter<BloodTestCreatorState> emit,
  ) async {
    await _bloodTestRepository.updateTest(
      bloodTestId: state.bloodTest!.id,
      userId: loggedUserId,
      date: state.date!,
      parameterResults: state.parameterResults!,
    );
    emitCompleteStatus(
      emit,
      BloodTestCreatorBlocInfo.bloodTestUpdated,
    );
  }

  Future<void> _addTest(
    String loggedUserId,
    Emitter<BloodTestCreatorState> emit,
  ) async {
    await _bloodTestRepository.addNewTest(
      userId: loggedUserId,
      date: state.date!,
      parameterResults: state.parameterResults!,
    );
    emitCompleteStatus(
      emit,
      BloodTestCreatorBlocInfo.bloodTestAdded,
    );
  }
}

enum BloodTestCreatorBlocInfo {
  bloodTestAdded,
  bloodTestUpdated,
}
