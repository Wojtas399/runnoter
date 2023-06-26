import 'package:firebase/firebase.dart';
import 'package:firebase/service/firebase_race_service.dart';
import 'package:mocktail/mocktail.dart';

class _FakeDuration extends Fake implements Duration {}

class _FakeRunStatusDto extends Fake implements RunStatusDto {}

class MockFirebaseRaceService extends Mock implements FirebaseRaceService {
  MockFirebaseRaceService() {
    registerFallbackValue(_FakeDuration());
    registerFallbackValue(_FakeRunStatusDto());
  }

  void mockLoadRaceById({
    RaceDto? raceDto,
  }) {
    when(
      () => loadRaceById(
        raceId: any(named: 'raceId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value(raceDto));
  }

  void mockLoadRacesByDateRange({
    List<RaceDto>? raceDtos,
  }) {
    when(
      () => loadRacesByDateRange(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value(raceDtos));
  }

  void mockLoadRacesByDate({
    List<RaceDto>? raceDtos,
  }) {
    when(
      () => loadRacesByDate(
        date: any(named: 'date'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value(raceDtos));
  }

  void mockLoadAllRaces({
    List<RaceDto>? raceDtos,
  }) {
    when(
      () => loadAllRaces(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value(raceDtos));
  }

  void mockAddNewRace({
    RaceDto? addedRaceDto,
  }) {
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
    ).thenAnswer((invocation) => Future.value(addedRaceDto));
  }

  void mockUpdateRace({
    RaceDto? updatedRaceDto,
  }) {
    when(
      () => updateRace(
        raceId: any(named: 'raceId'),
        userId: any(named: 'userId'),
        name: any(named: 'name'),
        date: any(named: 'date'),
        place: any(named: 'place'),
        distance: any(named: 'distance'),
        expectedDuration: any(named: 'expectedDuration'),
        setDurationAsNull: any(named: 'setDurationAsNull'),
        statusDto: any(named: 'statusDto'),
      ),
    ).thenAnswer((invocation) => Future.value(updatedRaceDto));
  }

  void mockDeleteRace() {
    when(
      () => deleteRace(
        raceId: any(named: 'raceId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  void mockDeleteAllUserRaces({
    required List<String> idsOfDeletedRaces,
  }) {
    when(
      () => deleteAllUserRaces(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value(idsOfDeletedRaces));
  }
}
