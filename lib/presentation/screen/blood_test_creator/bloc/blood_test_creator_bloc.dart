import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/model/blood_parameter.dart';
import '../../../../domain/model/blood_test.dart';
import '../../../../domain/repository/blood_test_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../model/bloc_state.dart';
import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';

part 'blood_test_creator_event.dart';
part 'blood_test_creator_state.dart';

class BloodTestCreatorBloc extends BlocWithStatus<BloodTestCreatorEvent,
    BloodTestCreatorState, BloodTestCreatorBlocInfo, dynamic> {
  final AuthService _authService;
  final BloodTestRepository _bloodTestRepository;

  BloodTestCreatorBloc({
    required AuthService authService,
    required BloodTestRepository bloodTestRepository,
    BloodTestCreatorState state = const BloodTestCreatorState(
      status: BlocStatusInitial(),
    ),
  })  : _authService = authService,
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
    if (event.bloodTestId == null) {
      return;
    }
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    final BloodTest? bloodTest = await _bloodTestRepository
        .getTestById(
          bloodTestId: event.bloodTestId!,
          userId: loggedUserId,
        )
        .first;
    if (bloodTest != null) {
      emit(state.copyWith(
        status: const BlocStatusComplete<BloodTestCreatorBlocInfo>(
          info: BloodTestCreatorBlocInfo.bloodTestDataInitialized,
        ),
        bloodTest: bloodTest,
        date: bloodTest.date,
        parameterResults: bloodTest.parameterResults,
      ));
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
    final int? parameterIndex = state.parameterResults?.indexWhere(
      (result) => result.parameter == event.parameter,
    );
    final updatedParameterResults = [...?state.parameterResults];
    BloodParameterResult? parameterResult;
    if (event.value != null) {
      parameterResult = BloodParameterResult(
        parameter: event.parameter,
        value: event.value!,
      );
    }
    if (parameterIndex != null && parameterIndex >= 0) {
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
    if (!state.canSubmit) {
      return;
    }
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
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
  bloodTestDataInitialized,
  bloodTestAdded,
}
