import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/entity/person.dart';
import 'package:runnoter/domain/repository/person_repository.dart';

class MockPersonRepository extends Mock implements PersonRepository {
  void mockGetPersonById({Person? person}) {
    when(
      () => getPersonById(
        personId: any(named: 'personId'),
      ),
    ).thenAnswer((_) => Stream.value(person));
  }

  void mockGetPersonsByCoachId({List<Person>? persons}) {
    when(
      () => getPersonsByCoachId(
        coachId: any(named: 'coachId'),
      ),
    ).thenAnswer((_) => Stream.value(persons));
  }

  void mockSearchForPersons({List<Person>? persons}) {
    when(
      () => searchForPersons(
        searchQuery: any(named: 'searchQuery'),
      ),
    ).thenAnswer((_) => Future.value(persons));
  }

  void mockRefreshPersonsByCoachId() {
    when(
      () => refreshPersonsByCoachId(
        coachId: any(named: 'coachId'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockRemoveCoachOfPerson() {
    when(
      () => removeCoachOfPerson(
        personId: any(named: 'personId'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
