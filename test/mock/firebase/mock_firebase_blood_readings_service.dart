import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseBloodReadingsService extends Mock
    implements FirebaseBloodReadingsService {
  void mockLoadAllReadings({
    List<BloodReadingsDto>? bloodReadingsDtos,
  }) {
    when(
      () => loadAllReadings(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value(bloodReadingsDtos));
  }

  void mockAddNewReadings({
    BloodReadingsDto? addedBloodReadingsDto,
  }) {
    when(
      () => addNewReadings(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        readings: any(named: 'readings'),
      ),
    ).thenAnswer((invocation) => Future.value(addedBloodReadingsDto));
  }
}
