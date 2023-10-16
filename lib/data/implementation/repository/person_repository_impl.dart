import 'package:collection/collection.dart';
import 'package:firebase/firebase.dart' as firebase;

import '../../../dependency_injection.dart';
import '../../interface/repository/person_repository.dart';
import '../../mapper/account_type_mapper.dart';
import '../../mapper/person_mapper.dart';
import '../../model/person.dart';
import '../../model/state_repository.dart';
import '../../model/user.dart';

class PersonRepositoryImpl extends StateRepository<Person>
    implements PersonRepository {
  final firebase.FirebaseUserService _dbUserService;

  PersonRepositoryImpl({super.initialData})
      : _dbUserService = getIt<firebase.FirebaseUserService>();

  @override
  Stream<Person?> getPersonById({required String personId}) {
    return dataStream$
        .map(
          (List<Person>? persons) => persons?.firstWhereOrNull(
            (Person p) => p.id == personId,
          ),
        )
        .asyncMap(
          (Person? person) async =>
              person ?? await _loadPersonByIdFromDb(personId),
        );
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
          (Person person) => _doesPersonMatch(person, searchQuery, accountType),
        ),
      ],
    );
    return await matchingPersons$.first;
  }

  @override
  Future<void> updateCoachIdOfPerson({
    required String personId,
    required String? coachId,
  }) async {
    final updatedUserDto = await _dbUserService.updateUserData(
      userId: personId,
      coachId: coachId,
      coachIdAsNull: coachId == null,
    );
    if (updatedUserDto != null) {
      final Person updatedPerson = mapPersonFromUserDto(updatedUserDto);
      updateEntity(updatedPerson);
    }
  }

  @override
  Future<void> refreshPersonById({required String personId}) async {
    await _loadPersonByIdFromDb(personId);
  }

  @override
  Future<void> refreshPersonsByCoachId({required String coachId}) async {
    await _loadPersonsByCoachIdFromDb(coachId);
  }

  @override
  Future<void> removeCoachIdInAllMatchingPersons({
    required String coachId,
  }) async {
    final updatedUserDtos = await _dbUserService
        .setCoachIdAsNullInAllMatchingUsers(coachId: coachId);
    if (updatedUserDtos.isNotEmpty) {
      final List<Person> updatedPersons =
          updatedUserDtos.map(mapPersonFromUserDto).toList();
      addOrUpdateEntities(updatedPersons);
    }
  }

  Future<Person?> _loadPersonByIdFromDb(String personId) async {
    final userDto = await _dbUserService.loadUserById(userId: personId);
    if (userDto == null) return null;
    final Person person = mapPersonFromUserDto(userDto);
    if (doesEntityNotExistInState(person.id)) {
      addEntity(person);
    } else {
      updateEntity(person);
    }
    return person;
  }

  Future<void> _loadPersonsByCoachIdFromDb(String coachId) async {
    final userDtos = await _dbUserService.loadUsersByCoachId(coachId: coachId);
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
    final foundUserDtos = await _dbUserService.searchForUsers(
      searchQuery: searchQuery,
      accountType: dtoAccountType,
    );
    final List<Person> persons =
        foundUserDtos.map(mapPersonFromUserDto).toList();
    addOrUpdateEntities(persons);
  }

  bool _doesPersonMatch(
    Person person,
    String searchQuery,
    AccountType? accountType,
  ) {
    if (accountType != null && person.accountType != accountType) return false;
    final String lowerCaseSearchQuery = searchQuery.toLowerCase();
    return person.name.toLowerCase().contains(lowerCaseSearchQuery) ||
        person.surname.toLowerCase().contains(lowerCaseSearchQuery) ||
        person.email.contains(lowerCaseSearchQuery);
  }
}
