import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/model/blood_parameter.dart';
import '../../../../domain/model/blood_reading.dart';
import '../../../../domain/repository/blood_reading_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../model/bloc_state.dart';
import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';

part 'blood_reading_creator_event.dart';
part 'blood_reading_creator_state.dart';

class BloodReadingCreatorBloc extends BlocWithStatus<BloodReadingCreatorEvent,
    BloodReadingCreatorState, BloodReadingCreatorBlocInfo, dynamic> {
  final AuthService _authService;
  final BloodReadingRepository _bloodReadingRepository;

  BloodReadingCreatorBloc({
    required AuthService authService,
    required BloodReadingRepository bloodReadingRepository,
    BlocStatus status = const BlocStatusInitial(),
    DateTime? date,
    List<BloodReadingParameter>? bloodReadingParameters,
  })  : _authService = authService,
        _bloodReadingRepository = bloodReadingRepository,
        super(
          BloodReadingCreatorState(
            status: status,
            date: date,
            bloodReadingParameters: bloodReadingParameters,
          ),
        ) {
    on<BloodReadingCreatorEventDateChanged>(_dateChanged);
    on<BloodReadingCreatorEventBloodReadingParameterChanged>(
      _bloodReadingParameterChanged,
    );
    on<BloodReadingCreatorEventSubmit>(_submit);
  }

  void _dateChanged(
    BloodReadingCreatorEventDateChanged event,
    Emitter<BloodReadingCreatorState> emit,
  ) {
    emit(state.copyWith(
      date: event.date,
    ));
  }

  void _bloodReadingParameterChanged(
    BloodReadingCreatorEventBloodReadingParameterChanged event,
    Emitter<BloodReadingCreatorState> emit,
  ) {
    final int? parameterIndex = state.bloodReadingParameters?.indexWhere(
      (el) => el.parameter == event.bloodParameter,
    );
    final updatedBloodReadingParameters = [...?state.bloodReadingParameters];
    BloodReadingParameter? parameter;
    if (event.parameterValue != null) {
      parameter = BloodReadingParameter(
        parameter: event.bloodParameter,
        readingValue: event.parameterValue!,
      );
    }
    if (parameterIndex != null && parameterIndex >= 0) {
      if (parameter != null) {
        updatedBloodReadingParameters[parameterIndex] = parameter;
      } else {
        updatedBloodReadingParameters.removeAt(parameterIndex);
      }
    } else if (parameter != null) {
      updatedBloodReadingParameters.add(parameter);
    }
    emit(state.copyWith(
      bloodReadingParameters: updatedBloodReadingParameters,
    ));
  }

  Future<void> _submit(
    BloodReadingCreatorEventSubmit event,
    Emitter<BloodReadingCreatorState> emit,
  ) async {
    if (!state.areDataValid) {
      return;
    }
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
    await _bloodReadingRepository.addNewReading(
      userId: loggedUserId,
      date: state.date!,
      parameters: state.bloodReadingParameters!,
    );
    emitCompleteStatus(
      emit,
      BloodReadingCreatorBlocInfo.bloodReadingAdded,
    );
  }
}

enum BloodReadingCreatorBlocInfo {
  bloodReadingAdded,
}
