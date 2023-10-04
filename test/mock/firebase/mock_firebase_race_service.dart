import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class _FakeDuration extends Fake implements Duration {}

class _FakeActivityStatusDto extends Fake implements ActivityStatusDto {}

class MockFirebaseRaceService extends Mock implements FirebaseRaceService {
  MockFirebaseRaceService() {
    registerFallbackValue(_FakeDuration());
    registerFallbackValue(_FakeActivityStatusDto());
  }

  void mockLoadRaceById({RaceDto? raceDto}) {
    when(
      () => loadRaceById(
        raceId: any(named: 'raceId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Future.value(raceDto));
  }

  void mockLoadRacesByDateRange({List<RaceDto>? raceDtos}) {
    when(
      () => loadRacesByDateRange(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Future.value(raceDtos));
  }

  void mockLoadRacesByDate({List<RaceDto>? raceDtos}) {
    when(
      () => loadRacesByDate(
        date: any(named: 'date'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Future.value(raceDtos));
  }

  void mockLoadRacesByUserId({List<RaceDto>? raceDtos}) {
    when(
      () => loadRacesByUserId(userId: any(named: 'userId')),
    ).thenAnswer((_) => Future.value(raceDtos));
  }

  void mockAddNewRace({RaceDto? addedRaceDto}) {
    when(
      () => addNewRace(
        userId: any(named: 'userId'),
        name: any(named: 'name'),
        date: any(named: 'date'),
        place: any(named: 'place'),
        distance: any(named: 'distance'),
        expectedDuration: any(named: 'expectedDuration'),
        statusDto: any(named: 'statusDto'),
      ),
    ).thenAnswer((_) => Future.value(addedRaceDto));
  }

  void mockUpdateRace({RaceDto? updatedRaceDto, Object? throwable}) {
    if (throwable != null) {
      when(_updateRaceCall).thenThrow(throwable);
    } else {
      when(_updateRaceCall).thenAnswer((_) => Future.value(updatedRaceDto));
    }
  }

  void mockDeleteRace() {
    when(
      () => deleteRace(
        raceId: any(named: 'raceId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockDeleteAllUserRaces({required List<String> idsOfDeletedRaces}) {
    when(
      () => deleteAllUserRaces(userId: any(named: 'userId')),
    ).thenAnswer((_) => Future.value(idsOfDeletedRaces));
  }

  Future<RaceDto?> _updateRaceCall() => updateRace(
        raceId: any(named: 'raceId'),
        userId: any(named: 'userId'),
        name: any(named: 'name'),
        date: any(named: 'date'),
        place: any(named: 'place'),
        distance: any(named: 'distance'),
        expectedDuration: any(named: 'expectedDuration'),
        setDurationAsNull: any(named: 'setDurationAsNull'),
        statusDto: any(named: 'statusDto'),
      );
}
