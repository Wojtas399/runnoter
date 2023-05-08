import 'package:firebase/firebase.dart';

import '../../domain/model/morning_measurement.dart';
import '../../domain/model/state_repository.dart';
import '../../domain/repository/morning_measurement_repository.dart';
import '../mapper/morning_measurement_mapper.dart';

class MorningMeasurementRepositoryImpl
    extends StateRepository<MorningMeasurement>
    implements MorningMeasurementRepository {
  final FirebaseMorningMeasurementService _firebaseMorningMeasurementService;

  MorningMeasurementRepositoryImpl({
    required FirebaseMorningMeasurementService
        firebaseMorningMeasurementService,
    List<MorningMeasurement>? initialState,
  })  : _firebaseMorningMeasurementService = firebaseMorningMeasurementService,
        super(initialData: initialState);

  @override
  Future<void> addMeasurement({
    required String userId,
    required MorningMeasurement measurement,
  }) async {
    final MorningMeasurementDto? morningMeasurementDto =
        await _firebaseMorningMeasurementService.addMeasurement(
      userId: userId,
      measurementDto: mapMorningMeasurementToFirebase(measurement),
    );
    if (morningMeasurementDto != null) {
      final MorningMeasurement morningMeasurement =
          mapMorningMeasurementFromFirebase(morningMeasurementDto);
      addEntity(morningMeasurement);
    }
  }
}
