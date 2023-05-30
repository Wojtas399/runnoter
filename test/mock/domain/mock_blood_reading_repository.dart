import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/blood_reading.dart';
import 'package:runnoter/domain/repository/blood_reading_repository.dart';

class MockBloodReadingRepository extends Mock
    implements BloodReadingRepository {
  void mockGetReadingById({
    BloodReading? bloodReading,
  }) {
    when(
      () => getReadingById(
        bloodReadingId: any(named: 'bloodReadingId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Stream.value(bloodReading));
  }

  void mockGetAllReadings({
    List<BloodReading>? readings,
  }) {
    when(
      () => getAllReadings(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Stream.value(readings));
  }

  void mockAddNewReading() {
    when(
      () => addNewReading(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        parameters: any(named: 'parameters'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }
}
