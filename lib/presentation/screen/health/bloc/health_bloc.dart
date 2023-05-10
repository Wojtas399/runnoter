import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/date_service.dart';
import '../../../../domain/model/morning_measurement.dart';
import '../../../../domain/repository/morning_measurement_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../model/bloc_state.dart';
import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';

part 'health_event.dart';
part 'health_state.dart';

class HealthBloc
    extends BlocWithStatus<HealthEvent, HealthState, HealthBlocInfo, dynamic> {
  final DateService _dateService;
  final AuthService _authService;
  final MorningMeasurementRepository _morningMeasurementRepository;

  HealthBloc({
    required DateService dateService,
    required AuthService authService,
    required MorningMeasurementRepository morningMeasurementRepository,
    BlocStatus status = const BlocStatusInitial(),
    MorningMeasurement? todayMorningMeasurement,
    ChartRange chartRange = ChartRange.week,
    List<MorningMeasurement>? morningMeasurements,
  })  : _dateService = dateService,
        _authService = authService,
        _morningMeasurementRepository = morningMeasurementRepository,
        super(
          HealthState(
            status: status,
            todayMorningMeasurement: todayMorningMeasurement,
            chartRange: chartRange,
            morningMeasurements: morningMeasurements,
          ),
        ) {
    on<HealthEventAddMorningMeasurement>(_addMorningMeasurement);
  }

  Future<void> _addMorningMeasurement(
    HealthEventAddMorningMeasurement event,
    Emitter<HealthState> emit,
  ) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      return;
    }
    emitLoadingStatus(emit);
    await _morningMeasurementRepository.addMeasurement(
      userId: loggedUserId,
      measurement: MorningMeasurement(
        date: _dateService.getTodayDate(),
        restingHeartRate: event.restingHeartRate,
        weight: event.weight,
      ),
    );
    emitCompleteStatus(emit, HealthBlocInfo.morningMeasurementAdded);
  }
}