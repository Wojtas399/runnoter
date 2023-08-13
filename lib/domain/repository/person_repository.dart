import '../entity/person.dart';
import '../entity/user.dart';

abstract interface class PersonRepository {
  Stream<Person?> getPersonById({required String personId});

  Stream<List<Person>?> getPersonsByCoachId({required String coachId});

  Future<List<Person>> searchForPersons({
    required String searchQuery,
    AccountType? accountType,
  });

  Future<void> refreshPersonsByCoachId({required String coachId});

  Future<void> removeCoachOfPerson({required String personId});
}
