import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseBloodReadingService extends Mock
    implements FirebaseBloodReadingService {
  void mockLoadAllReadings({
    List<BloodReadingDto>? bloodReadingDtos,
  }) {
    when(
      () => loadAllReadings(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value(bloodReadingDtos));
  }

  void mockAddNewReading({
    BloodReadingDto? addedBloodReadingDto,
  }) {
    when(
      () => addNewReading(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        parameters: any(named: 'parameters'),
      ),
    ).thenAnswer((invocation) => Future.value(addedBloodReadingDto));
  }
}
