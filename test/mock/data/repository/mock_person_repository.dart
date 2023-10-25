import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/model/person.dart';
import 'package:runnoter/data/repository/person/person_repository.dart';

class MockPersonRepository extends Mock implements PersonRepository {
  void mockGetPersonById({Person? person, Stream<Person?>? personStream}) {
    when(
      () => getPersonById(
        personId: any(named: 'personId'),
      ),
    ).thenAnswer((_) => personStream ?? Stream.value(person));
  }

  void mockGetPersonsByCoachId({
    List<Person>? persons,
    Stream<List<Person>?>? personsStream,
  }) {
    when(
      () => getPersonsByCoachId(
        coachId: any(named: 'coachId'),
      ),
    ).thenAnswer((_) => personsStream ?? Stream.value(persons));
  }

  void mockSearchForPersons({List<Person>? persons}) {
    when(
      () => searchForPersons(
        searchQuery: any(named: 'searchQuery'),
        accountType: any(named: 'accountType'),
      ),
    ).thenAnswer((_) => Future.value(persons));
  }

  void mockUpdateCoachIdOfPerson() {
    when(
      () => updateCoachIdOfPerson(
        personId: any(named: 'personId'),
        coachId: any(named: 'coachId'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockRefreshPersonById() {
    when(
      () => refreshPersonById(
        personId: any(named: 'personId'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockRefreshPersonsByCoachId() {
    when(
      () => refreshPersonsByCoachId(
        coachId: any(named: 'coachId'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockRemoveCoachIdInAllMatchingPersons() {
    when(
      () => removeCoachIdInAllMatchingPersons(
        coachId: any(named: 'coachId'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
