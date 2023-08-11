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
        gender: firebase.Gender.male,
        name: 'name1',
        surname: 'surname1',
        email: 'email1@example.com',
        coachId: 'c1',
      );
      final Person expectedPerson = Person(
        id: loadedUserDto.id,
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
          name: 'Eli',
          surname: 'Zabeth',
          email: 'eli@example.com',
        ),
        createPerson(
          id: 'u2',
          name: 'Jean',
          surname: 'Novsky',
          email: 'jean@example.com',
        ),
        createPerson(
          id: 'u3',
          name: 'Ste',
          surname: 'Phali',
          email: 'ste@example.com',
        ),
      ];
      final List<firebase.UserDto> loadedUserDtos = [
        createUserDto(
          id: 'u4',
          name: 'Jen',
          surname: 'Nna',
          email: 'jen@example.com.com',
        ),
        createUserDto(
          id: 'u5',
          name: 'Bart',
          surname: 'Osh',
          email: 'barli@example.com',
        ),
      ];
      final List<Person> expectedPersons = [
        existingPersons.first,
        existingPersons.last,
        createPerson(
          id: 'u5',
          name: 'Bart',
          surname: 'Osh',
          email: 'barli@example.com',
        ),
      ];
      firebaseUserService.mockSearchForUsers(userDtos: loadedUserDtos);
      repository = PersonRepositoryImpl(initialData: existingPersons);

      final List<Person> persons = await repository.searchForPersons(
        searchQuery: 'li',
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
                name: 'Jen',
                surname: 'Nna',
                email: 'jen@example.com.com',
              ),
              createPerson(
                id: 'u5',
                name: 'Bart',
                surname: 'Osh',
                email: 'barli@example.com',
              ),
            ]
          ],
        ),
      );
    },
  );
}
