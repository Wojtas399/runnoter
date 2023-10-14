import '../../data/entity/person.dart';
import '../entity/user.dart';

abstract interface class PersonRepository {
  Stream<Person?> getPersonById({required String personId});

  Stream<List<Person>?> getPersonsByCoachId({required String coachId});

  Future<List<Person>> searchForPersons({
    required String searchQuery,
    AccountType? accountType,
  });

  Future<void> updateCoachIdOfPerson({
    required String personId,
    required String? coachId,
  });

  Future<void> refreshPersonById({required String personId});

  Future<void> refreshPersonsByCoachId({required String coachId});

  Future<void> removeCoachIdInAllMatchingPersons({required String coachId});
}
