import 'package:collection/collection.dart';
import 'package:firebase/firebase.dart';

import '../../dependency_injection.dart';
import '../../domain/additional_model/state_repository.dart';
import '../../domain/entity/person.dart';
import '../../domain/repository/person_repository.dart';
import '../mapper/person_mapper.dart';

class PersonRepositoryImpl extends StateRepository<Person>
    implements PersonRepository {
  final FirebaseUserService _firebaseUserService;

  PersonRepositoryImpl({super.initialData})
      : _firebaseUserService = getIt<FirebaseUserService>();

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
  Future<List<Person>> searchForPersons({required searchQuery}) async {
    await _searchForPersonsInDb(searchQuery);
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

  Future<Person?> _loadPersonByIdFromDb(String personId) async {
    final userDto = await _firebaseUserService.loadUserById(userId: personId);
    if (userDto == null) return null;
    final Person person = mapPersonFromUserDto(userDto);
    addEntity(person);
    return person;
  }

  Future<void> _loadPersonsByCoachIdFromDb(String coachId) async {
    final List<UserDto> userDtos =
        await _firebaseUserService.loadUsersByCoachId(coachId: coachId);
    if (userDtos.isEmpty) return;
    final List<Person> persons = userDtos.map(mapPersonFromUserDto).toList();
    addOrUpdateEntities(persons);
  }

  Future<void> _searchForPersonsInDb(String searchQuery) async {
    final List<UserDto> foundUserDtos =
        await _firebaseUserService.searchForUsers(searchQuery: searchQuery);
    final List<Person> persons =
        foundUserDtos.map(mapPersonFromUserDto).toList();
    addOrUpdateEntities(persons);
  }
}
