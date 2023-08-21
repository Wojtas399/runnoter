import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/activity_status.dart';
import 'package:runnoter/domain/entity/race.dart';
import 'package:runnoter/domain/repository/race_repository.dart';

class _FakeDuration extends Fake implements Duration {}

class MockRaceRepository extends Mock implements RaceRepository {
  MockRaceRepository() {
    registerFallbackValue(_FakeDuration());
    registerFallbackValue(const ActivityStatusPending());
  }

  void mockGetRaceById({
    Race? race,
    Stream<Race?>? raceStream,
  }) {
    when(
      () => getRaceById(
        raceId: any(named: 'raceId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => raceStream ?? Stream.value(race));
  }

  void mockGetRacesByDateRange({
    List<Race>? races,
    Stream<List<Race>?>? racesStream,
  }) {
    when(
      () => getRacesByDateRange(
        userId: any(named: 'userId'),
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
      ),
    ).thenAnswer((_) => racesStream ?? Stream.value(races));
  }

  void mockGetRacesByDate({
    List<Race>? races,
    Stream<List<Race>?>? racesStream,
  }) {
    when(
      () => getRacesByDate(
        date: any(named: 'date'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => racesStream ?? Stream.value(races));
  }

  void mockGetAllRaces({
    List<Race>? races,
    Stream<List<Race>?>? racesStream,
  }) {
    when(
      () => getAllRaces(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => racesStream ?? Stream.value(races));
  }

  void mockAddNewRace() {
    when(
      () => addNewRace(
        userId: any(named: 'userId'),
        name: any(named: 'name'),
        date: any(named: 'date'),
        place: any(named: 'place'),
        distance: any(named: 'distance'),
        expectedDuration: any(named: 'expectedDuration'),
        status: any(named: 'status'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockUpdateRace() {
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
        status: any(named: 'status'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockDeleteRace() {
    when(
      () => deleteRace(
        raceId: any(named: 'raceId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  void mockDeleteAllUserRaces() {
    when(
      () => deleteAllUserRaces(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
