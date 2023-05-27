import 'package:firebase/firebase.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/model/blood_reading.dart';
import '../../domain/model/state_repository.dart';
import '../../domain/repository/blood_reading_repository.dart';
import '../mapper/blood_reading_mapper.dart';
import '../mapper/blood_reading_parameter_mapper.dart';

class BloodReadingRepositoryImpl extends StateRepository<BloodReading>
    implements BloodReadingRepository {
  final FirebaseBloodReadingService _firebaseBloodReadingService;

  BloodReadingRepositoryImpl({
    required FirebaseBloodReadingService firebaseBloodReadingsService,
    super.initialData,
  }) : _firebaseBloodReadingService = firebaseBloodReadingsService;

  @override
  Stream<List<BloodReading>?> getAllReadings({
    required String userId,
  }) =>
      dataStream$
          .map(
            (List<BloodReading>? readings) => readings
                ?.where(
                  (singleBloodReadings) => singleBloodReadings.userId == userId,
                )
                .toList(),
          )
          .doOnListen(
            () => _loadReadingsFromRemoteDb(userId),
          );

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
