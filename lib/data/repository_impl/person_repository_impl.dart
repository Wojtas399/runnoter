import 'package:collection/collection.dart';
import 'package:firebase/firebase.dart' as firebase;

import '../../dependency_injection.dart';
import '../../domain/additional_model/state_repository.dart';
import '../../domain/entity/person.dart';
import '../../domain/entity/user.dart';
import '../../domain/repository/person_repository.dart';
import '../mapper/account_type_mapper.dart';
import '../mapper/person_mapper.dart';

class PersonRepositoryImpl extends StateRepository<Person>
    implements PersonRepository {
  final firebase.FirebaseUserService _firebaseUserService;

  PersonRepositoryImpl({super.initialData})
      : _firebaseUserService = getIt<firebase.FirebaseUserService>();

  @override
  Stream<Person?> getPersonById({required String personId}) async* {
    await for (final persons in dataStream$) {
      Person? person = persons?.firstWhereOrNull(
        (Person p) => p.id == personId,
      );
      person ??= await _loadPersonByIdFromDb(personId);
      yield person;
    }
  }

  @override
  Stream<List<Person>?> getPersonsByCoachId({required String coachId}) async* {
    await _loadPersonsByCoachIdFromDb(coachId);
    await for (final persons in dataStream$) {
      yield persons?.where((Person p) => p.coachId == coachId).toList();
    }
  }

  @override
  Future<List<Person>> searchForPersons({
    required searchQuery,
    AccountType? accountType,
  }) async {
    await _searchForPersonsInDb(searchQuery, accountType);
    final Stream<List<Person>> matchingPersons$ = dataStream$.map(
      (List<Person>? persons) => [
        ...?persons?.where(
          (Person person) {
            final String lowerCaseSearchQuery = searchQuery.toLowerCase();
            bool doesNameMatch =
                person.name.toLowerCase().contains(lowerCaseSearchQuery);
            bool doesSurnameMatch =
                person.surname.toLowerCase().contains(lowerCaseSearchQuery);
            bool doesEmailMatch =
                person.email.toLowerCase().contains(lowerCaseSearchQuery);
            return doesNameMatch || doesSurnameMatch || doesEmailMatch;
          },
        ),
      ],
    );
    return await matchingPersons$.first;
  }

  @override
  Future<void> refreshPersonsByCoachId({required String coachId}) async {
    await _loadPersonsByCoachIdFromDb(coachId);
  }

  @override
  Future<void> removeCoachOfPerson({required String personId}) async {
    final updatedUserDto = await _firebaseUserService.updateUserData(
      userId: personId,
      coachIdAsNull: true,
    );
    if (updatedUserDto != null) {
      final Person updatedPerson = mapPersonFromUserDto(updatedUserDto);
      updateEntity(updatedPerson);
    }
  }

  Future<Person?> _loadPersonByIdFromDb(String personId) async {
    final userDto = await _firebaseUserService.loadUserById(userId: personId);
    if (userDto == null) return null;
    final Person person = mapPersonFromUserDto(userDto);
    addEntity(person);
    return person;
  }

  Future<void> _loadPersonsByCoachIdFromDb(String coachId) async {
    final userDtos =
        await _firebaseUserService.loadUsersByCoachId(coachId: coachId);
    if (userDtos.isEmpty) return;
    final List<Person> persons = userDtos.map(mapPersonFromUserDto).toList();
    addOrUpdateEntities(persons);
  }

  Future<void> _searchForPersonsInDb(
    String searchQuery,
    AccountType? accountType,
  ) async {
    firebase.AccountType? dtoAccountType;
    if (accountType != null) dtoAccountType = mapAccountTypeToDto(accountType);
    final foundUserDtos = await _firebaseUserService.searchForUsers(
      searchQuery: searchQuery,
      accountType: dtoAccountType,
    );
    final List<Person> persons =
        foundUserDtos.map(mapPersonFromUserDto).toList();
    addOrUpdateEntities(persons);
  }
}
