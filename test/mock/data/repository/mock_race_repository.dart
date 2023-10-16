import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/interface/repository/race_repository.dart';
import 'package:runnoter/data/model/activity.dart';
import 'package:runnoter/data/model/race.dart';

class _FakeDuration extends Fake implements Duration {}

class MockRaceRepository extends Mock implements RaceRepository {
  MockRaceRepository() {
    registerFallbackValue(_FakeDuration());
    registerFallbackValue(const ActivityStatusPending());
  }

  void mockGetRaceById({Race? race, Stream<Race?>? raceStream}) {
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

  void mockGetRacesByUserId({
    List<Race>? races,
    Stream<List<Race>?>? racesStream,
  }) {
    when(
      () => getRacesByUserId(userId: any(named: 'userId')),
    ).thenAnswer((_) => racesStream ?? Stream.value(races));
  }

  void mockRefreshRacesByDateRange() {
    when(
      () => refreshRacesByDateRange(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockRefreshRacesByUserId() {
    when(
      () => refreshRacesByUserId(userId: any(named: 'userId')),
    ).thenAnswer((_) => Future.value());
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

  void mockUpdateRace({Object? throwable}) {
    if (throwable != null) {
      when(_updateRaceCall).thenThrow(throwable);
    } else {
      when(_updateRaceCall).thenAnswer((_) => Future.value());
    }
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
      () => deleteAllUserRaces(userId: any(named: 'userId')),
    ).thenAnswer((_) => Future.value());
  }

  Future<void> _updateRaceCall() => updateRace(
        raceId: any(named: 'raceId'),
        userId: any(named: 'userId'),
        name: any(named: 'name'),
        date: any(named: 'date'),
        place: any(named: 'place'),
        distance: any(named: 'distance'),
        expectedDuration: any(named: 'expectedDuration'),
        setDurationAsNull: any(named: 'setDurationAsNull'),
        status: any(named: 'status'),
      );
}
