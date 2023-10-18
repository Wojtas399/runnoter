import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/implementation/repository/person_repository_impl.dart';
import 'package:runnoter/data/model/person.dart';
import 'package:runnoter/data/model/user.dart';

import '../../creators/person_creator.dart';
import '../../creators/user_dto_creator.dart';
import '../../mock/firebase/mock_firebase_user_service.dart';

void main() {
  final dbUserService = MockFirebaseUserService();
  late PersonRepositoryImpl repository;

  setUpAll(() {
    GetIt.I.registerSingleton<firebase.FirebaseUserService>(
      dbUserService,
    );
  });

  setUp(() => repository = PersonRepositoryImpl());

  tearDown(() {
    reset(dbUserService);
  });

  test(
    'getPersonById, '
    'person exists in repository, '
    'should emit matching person from repo',
    () {
      final List<Person> existingPersons = [
        createPerson(id: 'u1', name: 'name1', surname: 'surname1'),
        createPerson(id: 'u2', name: 'name2', surname: 'surname2'),
      ];
      repository = PersonRepositoryImpl(initialData: existingPersons);

      final Stream<Person?> person$ = repository.getPersonById(personId: 'u1');

      expect(person$, emitsInOrder([existingPersons.first]));
    },
  );

  test(
    'getPersonById, '
    'person does not exist in repository, '
    'should load person from db, add him to repository and emit',
    () {
      final List<Person> existingPersons = [
        createPerson(id: 'u2', name: 'name2', surname: 'surname2'),
      ];
      final firebase.UserDto loadedUserDto = createUserDto(
        id: 'u1',
        accountType: firebase.AccountType.coach,
        gender: firebase.Gender.male,
        name: 'name1',
        surname: 'surname1',
        email: 'email1@example.com',
        dateOfBirth: DateTime(2003, 1, 10),
        coachId: 'c1',
      );
      final Person expectedPerson = Person(
        id: loadedUserDto.id,
        accountType: AccountType.coach,
        gender: Gender.male,
        name: loadedUserDto.name,
        surname: loadedUserDto.surname,
        email: loadedUserDto.email,
        dateOfBirth: loadedUserDto.dateOfBirth,
        coachId: loadedUserDto.coachId,
      );
      repository = PersonRepositoryImpl(initialData: existingPersons);
      dbUserService.mockLoadUserById(userDto: loadedUserDto);

      final Stream<Person?> person$ = repository.getPersonById(personId: 'u1');
      final Stream<List<Person>?> repositoryState$ =
          repository.repositoryState$;

      expect(person$, emitsInOrder([expectedPerson]));
      expect(
        repositoryState$,
        emitsInOrder([
          existingPersons,
          [...existingPersons, expectedPerson],
        ]),
      );
    },
  );

  test(
    'getPersonsByCoachId, '
    'should load persons from db, add them to repository and should emit all persons with matching coach id',
    () {
      const String coachId = 'c1';
      final List<Person> existingPersons = [
        createPerson(id: 'u1', coachId: coachId),
        createPerson(id: 'u2', coachId: coachId),
        createPerson(id: 'u3', coachId: 'c2'),
        createPerson(id: 'u4'),
      ];
      final List<firebase.UserDto> loadedUserDtos = [
        createUserDto(id: 'u5', coachId: coachId),
        createUserDto(id: 'u6', coachId: coachId),
      ];
      final List<Person> loadedPersons = [
        createPerson(id: 'u5', coachId: coachId),
        createPerson(id: 'u6', coachId: coachId),
      ];
      dbUserService.mockLoadUsersByCoachId(users: loadedUserDtos);
      repository = PersonRepositoryImpl(initialData: existingPersons);

      final Stream<List<Person>?> persons$ =
          repository.getPersonsByCoachId(coachId: coachId);
      final Stream<List<Person>?> repositoryState$ =
          repository.repositoryState$;

      expect(
        persons$,
        emitsInOrder([
          [existingPersons.first, existingPersons[1], ...loadedPersons],
        ]),
      );
      expect(
        repositoryState$,
        emitsInOrder([
          existingPersons,
          [...existingPersons, ...loadedPersons],
        ]),
      );
    },
  );

  test(
    'searchForPersons, '
    'should load matching persons from db, add them to repository and should return all matching persons from repository',
    () async {
      final List<Person> existingPersons = [
        createPerson(
          id: 'u1',
          accountType: AccountType.coach,
          name: 'Eli',
          surname: 'Zabeth',
          email: 'eli@example.com',
        ),
        createPerson(
          id: 'u2',
          accountType: AccountType.coach,
          name: 'Jean',
          surname: 'Novsky',
          email: 'jean@example.com',
        ),
        createPerson(
          id: 'u3',
          accountType: AccountType.runner,
          name: 'Ste',
          surname: 'Phali',
          email: 'ste@example.com',
        ),
      ];
      final List<firebase.UserDto> loadedUserDtos = [
        createUserDto(
          id: 'u4',
          accountType: firebase.AccountType.coach,
          name: 'Jen',
          surname: 'li',
          email: 'jen@example.com.com',
        ),
        createUserDto(
          id: 'u5',
          accountType: firebase.AccountType.coach,
          name: 'Bart',
          surname: 'Osh',
          email: 'barli@example.com',
        ),
      ];
      final List<Person> expectedPersons = [
        existingPersons.first,
        createPerson(
          id: 'u4',
          accountType: AccountType.coach,
          name: 'Jen',
          surname: 'li',
          email: 'jen@example.com.com',
        ),
        createPerson(
          id: 'u5',
          accountType: AccountType.coach,
          name: 'Bart',
          surname: 'Osh',
          email: 'barli@example.com',
        ),
      ];
      dbUserService.mockSearchForUsers(userDtos: loadedUserDtos);
      repository = PersonRepositoryImpl(initialData: existingPersons);

      final List<Person> persons = await repository.searchForPersons(
        searchQuery: 'li',
        accountType: AccountType.coach,
      );
      final Stream<List<Person>?> repositoryState$ =
          repository.repositoryState$;

      expect(persons, expectedPersons);
      expect(
        repositoryState$,
        emitsInOrder(
          [
            [
              ...existingPersons,
              createPerson(
                id: 'u4',
                accountType: AccountType.coach,
                name: 'Jen',
                surname: 'li',
                email: 'jen@example.com.com',
              ),
              createPerson(
                id: 'u5',
                accountType: AccountType.coach,
                name: 'Bart',
                surname: 'Osh',
                email: 'barli@example.com',
              ),
            ]
          ],
        ),
      );
      verify(
        () => dbUserService.searchForUsers(
          searchQuery: 'li',
          accountType: firebase.AccountType.coach,
        ),
      ).called(1);
    },
  );

  test(
    'updateCoachIdOfPerson, '
    'should update user in db and in repo with coachId',
    () async {
      const String personId = 'u1';
      const String coachId = 'c1';
      final List<Person> existingPersons = [
        createPerson(id: 'u1', coachId: null),
        createPerson(id: 'u2', coachId: coachId),
      ];
      final firebase.UserDto updatedUserDto = createUserDto(
        id: personId,
        coachId: coachId,
      );
      final Person updatedPerson = createPerson(id: personId, coachId: coachId);
      repository = PersonRepositoryImpl(initialData: existingPersons);
      dbUserService.mockUpdateUserData(userDto: updatedUserDto);

      await repository.updateCoachIdOfPerson(
        personId: personId,
        coachId: coachId,
      );
      final Stream<List<Person>?> repoState$ = repository.repositoryState$;

      expect(
        repoState$,
        emitsInOrder([
          [updatedPerson, existingPersons.last],
        ]),
      );
      verify(
        () => dbUserService.updateUserData(
          userId: personId,
          coachId: coachId,
        ),
      ).called(1);
    },
  );

  test(
    'updateCoachIdOfPerson, '
    'coach id is null, '
    'should call db method to update user with coachIdAsNull set to true and should update user in state',
    () async {
      const String personId = 'u1';
      const String coachId = 'c1';
      final List<Person> existingPersons = [
        createPerson(id: 'u1', coachId: coachId),
        createPerson(id: 'u2', coachId: coachId),
      ];
      final firebase.UserDto updatedUserDto = createUserDto(
        id: personId,
        coachId: null,
      );
      final Person updatedPerson = createPerson(id: personId, coachId: null);
      repository = PersonRepositoryImpl(initialData: existingPersons);
      dbUserService.mockUpdateUserData(userDto: updatedUserDto);

      await repository.updateCoachIdOfPerson(personId: personId, coachId: null);
      final Stream<List<Person>?> repoState$ = repository.repositoryState$;

      expect(
        repoState$,
        emitsInOrder([
          [updatedPerson, existingPersons.last],
        ]),
      );
      verify(
        () => dbUserService.updateUserData(
          userId: personId,
          coachIdAsNull: true,
        ),
      ).called(1);
    },
  );

  test(
    'refreshPersonById, '
    'person does not exist in repo, '
    'should load person from db and add it to repo',
    () async {
      const String personId = 'p1';
      final List<Person> existingPersons = [
        createPerson(id: 'p2'),
        createPerson(id: 'p3')
      ];
      final firebase.UserDto loadedUserDto = createUserDto(
        id: personId,
        name: 'person',
        surname: 'surname',
      );
      final Person loadedPerson = createPerson(
        id: personId,
        name: 'person',
        surname: 'surname',
      );
      dbUserService.mockLoadUserById(userDto: loadedUserDto);
      repository = PersonRepositoryImpl(initialData: existingPersons);

      await repository.refreshPersonById(personId: personId);

      expect(
        repository.repositoryState$,
        emits([...existingPersons, loadedPerson]),
      );
      verify(() => dbUserService.loadUserById(userId: personId)).called(1);
    },
  );

  test(
    'refreshPersonById, '
    'person exists in repo, '
    'should load person from db and update it in repo',
    () async {
      const String personId = 'p1';
      final List<Person> existingPersons = [
        createPerson(id: personId),
        createPerson(id: 'p2'),
        createPerson(id: 'p3')
      ];
      final firebase.UserDto loadedUserDto = createUserDto(
        id: personId,
        name: 'person',
        surname: 'surname',
      );
      final Person loadedPerson = createPerson(
        id: personId,
        name: 'person',
        surname: 'surname',
      );
      dbUserService.mockLoadUserById(userDto: loadedUserDto);
      repository = PersonRepositoryImpl(initialData: existingPersons);

      await repository.refreshPersonById(personId: personId);

      expect(
        repository.repositoryState$,
        emits([loadedPerson, existingPersons[1], existingPersons[2]]),
      );
      verify(() => dbUserService.loadUserById(userId: personId)).called(1);
    },
  );

  test(
    'refreshPersonsByCoachId, '
    'should load persons by coach id from db and should update them in state',
    () async {
      const String coachId = 'c1';
      final List<Person> existingPersons = [
        createPerson(id: 'u1', name: 'name1', coachId: coachId),
        createPerson(id: 'u2', name: 'name2', coachId: coachId),
      ];
      final List<firebase.UserDto> loadedUserDtos = [
        createUserDto(id: 'u1', name: 'new name1', coachId: coachId),
        createUserDto(id: 'u2', name: 'new name2', coachId: coachId),
        createUserDto(id: 'u3', name: 'new name3', coachId: coachId),
      ];
      final List<Person> expectedPersons = [
        createPerson(id: 'u1', name: 'new name1', coachId: coachId),
        createPerson(id: 'u2', name: 'new name2', coachId: coachId),
        createPerson(id: 'u3', name: 'new name3', coachId: coachId),
      ];
      dbUserService.mockLoadUsersByCoachId(users: loadedUserDtos);
      repository = PersonRepositoryImpl(initialData: existingPersons);

      final Stream<List<Person>?> repositoryState$ =
          repository.repositoryState$;
      repository.refreshPersonsByCoachId(coachId: coachId);

      expect(
        repositoryState$,
        emitsInOrder([
          existingPersons,
          expectedPersons,
        ]),
      );
    },
  );

  test(
    'removeCoachIdInAllMatchingUsers, '
    'should call db method to set coach id as null in all matching users and should update these users in repo',
    () async {
      const String coachId = 'c1';
      final List<Person> existingPersons = [
        createPerson(id: 'u1', coachId: coachId),
        createPerson(id: 'u2', coachId: 'c2'),
        createPerson(id: 'u3', coachId: coachId),
        createPerson(id: 'u4', coachId: 'c3'),
      ];
      final List<firebase.UserDto> updatedUserDtos = [
        createUserDto(id: 'u1', coachId: null),
        createUserDto(id: 'u3', coachId: null),
      ];
      final List<Person> updatedUsers = [
        createPerson(id: 'u1', coachId: null),
        existingPersons[1],
        createPerson(id: 'u3', coachId: null),
        existingPersons.last,
      ];
      dbUserService.mockSetCoachIdAsNullInAllMatchingUsers(
        updatedUserDtos: updatedUserDtos,
      );
      repository = PersonRepositoryImpl(initialData: existingPersons);

      final Stream<List<Person>?> repoState$ = repository.repositoryState$;
      await repository.removeCoachIdInAllMatchingPersons(coachId: coachId);

      expect(repoState$, emitsInOrder([updatedUsers]));
      verify(
        () => dbUserService.setCoachIdAsNullInAllMatchingUsers(
          coachId: coachId,
        ),
      ).called(1);
    },
  );
}
