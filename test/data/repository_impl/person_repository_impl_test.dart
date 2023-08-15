import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/repository_impl/person_repository_impl.dart';
import 'package:runnoter/domain/entity/person.dart';
import 'package:runnoter/domain/entity/user.dart';

import '../../creators/person_creator.dart';
import '../../creators/user_dto_creator.dart';
import '../../mock/firebase/mock_firebase_user_service.dart';

void main() {
  final firebaseUserService = MockFirebaseUserService();
  late PersonRepositoryImpl repository;

  setUpAll(() {
    GetIt.I.registerSingleton<firebase.FirebaseUserService>(
      firebaseUserService,
    );
  });

  setUp(() => repository = PersonRepositoryImpl());

  tearDown(() {
    reset(firebaseUserService);
  });

  test(
    'get person by id, '
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
    'get person by id, '
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
        coachId: 'c1',
      );
      final Person expectedPerson = Person(
        id: loadedUserDto.id,
        accountType: AccountType.coach,
        gender: Gender.male,
        name: loadedUserDto.name,
        surname: loadedUserDto.surname,
        email: loadedUserDto.email,
        coachId: loadedUserDto.coachId,
      );
      repository = PersonRepositoryImpl(initialData: existingPersons);
      firebaseUserService.mockLoadUserById(userDto: loadedUserDto);

      final Stream<Person?> person$ = repository.getPersonById(personId: 'u1');
      final Stream<List<Person>?> repositoryState$ = repository.dataStream$;

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
    'get persons by coach id, '
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
      firebaseUserService.mockLoadUsersByCoachId(users: loadedUserDtos);
      repository = PersonRepositoryImpl(initialData: existingPersons);

      final Stream<List<Person>?> persons$ =
          repository.getPersonsByCoachId(coachId: coachId);
      final Stream<List<Person>?> repositoryState$ = repository.dataStream$;

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
    'search for persons, '
    'should load matching persons from firebase, add them to repository and should return all matching persons from repository',
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
      firebaseUserService.mockSearchForUsers(userDtos: loadedUserDtos);
      repository = PersonRepositoryImpl(initialData: existingPersons);

      final List<Person> persons = await repository.searchForPersons(
        searchQuery: 'li',
        accountType: AccountType.coach,
      );
      final Stream<List<Person>?> repositoryState$ = repository.dataStream$;

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
        () => firebaseUserService.searchForUsers(
          searchQuery: 'li',
          accountType: firebase.AccountType.coach,
        ),
      ).called(1);
    },
  );

  test(
    'update coachId of person, '
    "should call firebase user service's method to update user with coachId and should update user in state",
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
      firebaseUserService.mockUpdateUserData(userDto: updatedUserDto);

      await repository.updateCoachIdOfPerson(
        personId: personId,
        coachId: coachId,
      );
      final Stream<List<Person>?> repoState$ = repository.dataStream$;

      expect(
        repoState$,
        emitsInOrder([
          [updatedPerson, existingPersons.last],
        ]),
      );
      verify(
        () => firebaseUserService.updateUserData(
          userId: personId,
          coachId: coachId,
        ),
      ).called(1);
    },
  );

  test(
    'update coachId of person, '
    'coach id is null, '
    "should call firebase user service's method to update user with coachIdAsNull set to true and should update user in state",
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
      firebaseUserService.mockUpdateUserData(userDto: updatedUserDto);

      await repository.updateCoachIdOfPerson(personId: personId, coachId: null);
      final Stream<List<Person>?> repoState$ = repository.dataStream$;

      expect(
        repoState$,
        emitsInOrder([
          [updatedPerson, existingPersons.last],
        ]),
      );
      verify(
        () => firebaseUserService.updateUserData(
          userId: personId,
          coachIdAsNull: true,
        ),
      ).called(1);
    },
  );

  test(
    'refresh persons by coach id, '
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
      firebaseUserService.mockLoadUsersByCoachId(users: loadedUserDtos);
      repository = PersonRepositoryImpl(initialData: existingPersons);

      final Stream<List<Person>?> repositoryState$ = repository.dataStream$;
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
    'remove coach of person, '
    "should call firebase user service's method to update user with coach set as null and should update user in state",
    () async {
      final List<Person> existingPersons = [
        createPerson(id: 'p1', coachId: 'c1'),
        createPerson(id: 'p2', coachId: 'c2'),
        createPerson(id: 'p3', coachId: null),
      ];
      final firebase.UserDto updatedUserDto = createUserDto(
        id: 'p1',
        coachId: null,
      );
      final Person expectedUpdatedPerson = createPerson(
        id: 'p1',
        coachId: null,
      );
      firebaseUserService.mockUpdateUserData(userDto: updatedUserDto);
      repository = PersonRepositoryImpl(initialData: existingPersons);

      final Stream<Person?> person$ = repository.getPersonById(personId: 'p1');
      await repository.removeCoachOfPerson(personId: 'p1');

      expect(person$, emitsInOrder([expectedUpdatedPerson]));
      verify(
        () => firebaseUserService.updateUserData(
          userId: 'p1',
          coachIdAsNull: true,
        ),
      ).called(1);
    },
  );
}
