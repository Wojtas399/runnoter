import 'package:firebase/firebase.dart' as firebase;

import '../../domain/model/blood_parameter.dart';
import '../../domain/model/blood_reading.dart';
import '../../domain/model/state_repository.dart';
import '../../domain/repository/blood_reading_repository.dart';
import '../mapper/blood_reading_mapper.dart';
import '../mapper/blood_reading_parameter_mapper.dart';

class BloodReadingRepositoryImpl extends StateRepository<BloodReading>
    implements BloodReadingRepository {
  final firebase.FirebaseBloodReadingService _firebaseBloodReadingService;

  BloodReadingRepositoryImpl({
    required firebase.FirebaseBloodReadingService firebaseBloodReadingsService,
    super.initialData,
  }) : _firebaseBloodReadingService = firebaseBloodReadingsService;

  @override
  Stream<BloodReading?> getReadingById({
    required String bloodReadingId,
    required String userId,
  }) {
    return Stream.value(
      BloodReading(
        id: bloodReadingId,
        userId: userId,
        date: DateTime(2023, 5, 10),
        parameters: [
          BloodReadingParameter(
            parameter: BloodParameter.wbc,
            readingValue: 4.45,
          ),
          BloodReadingParameter(
            parameter: BloodParameter.cpk,
            readingValue: 300,
          ),
        ],
      ),
    );
  }

  @override
  Stream<List<BloodReading>?> getAllReadings({
    required String userId,
  }) async* {
    await _loadReadingsFromRemoteDb(userId);
    await for (final readings in dataStream$) {
      yield readings
          ?.where((bloodReading) => bloodReading.userId == userId)
          .toList();
    }
  }

  @override
  Future<void> addNewReading({
    required String userId,
    required DateTime date,
    required List<BloodReadingParameter> parameters,
  }) async {
    final addedBloodReadingDto =
        await _firebaseBloodReadingService.addNewReading(
      userId: userId,
      date: date,
      parameters: parameters.map(mapBloodReadingParameterToDto).toList(),
    );
    if (addedBloodReadingDto != null) {
      final BloodReading bloodReading = mapBloodReadingFromDto(
        addedBloodReadingDto,
      );
      addEntity(bloodReading);
    }
  }

  @override
  Future<void> deleteReading({
    required String bloodReadingId,
    required String userId,
  }) async {
    throw UnimplementedError();
  }

  Future<void> _loadReadingsFromRemoteDb(String userId) async {
    final readingsDtos = await _firebaseBloodReadingService.loadAllReadings(
      userId: userId,
    );
    if (readingsDtos != null) {
      final List<BloodReading> readings =
          readingsDtos.map(mapBloodReadingFromDto).toList();
      addEntities(readings);
    }
  }
}
