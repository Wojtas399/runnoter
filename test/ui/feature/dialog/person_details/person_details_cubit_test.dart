import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/entity/person.dart';
import 'package:runnoter/data/entity/user.dart';
import 'package:runnoter/data/interface/repository/person_repository.dart';
import 'package:runnoter/ui/feature/dialog/person_details/cubit/person_details_cubit.dart';

import '../../../../creators/person_creator.dart';
import '../../../../mock/domain/repository/mock_person_repository.dart';

void main() {
  final personRepository = MockPersonRepository();
  const String personId = 'c1';

  PersonDetailsCubit createCubit() => PersonDetailsCubit(personId: personId);

  setUpAll(() {
    GetIt.I.registerSingleton<PersonRepository>(personRepository);
  });

  tearDown(() {
    reset(personRepository);
  });

  group(
    'initialize',
    () {
      final Person person = createPerson(
        id: personId,
        gender: Gender.male,
        name: 'client name',
        surname: 'client surname',
        email: 'client.email@example.com',
        dateOfBirth: DateTime(2001, 1, 10),
      );
      final Person updatedPerson = createPerson(
        id: personId,
        gender: Gender.male,
        name: 'updated client name',
        surname: 'updated client surname',
        email: 'updated client.email@example.com',
        dateOfBirth: DateTime(2002, 1, 10),
      );
      final StreamController<Person?> person$ = StreamController()..add(person);

      blocTest(
        'should set listener of person',
        build: () => createCubit(),
        setUp: () => personRepository.mockGetPersonById(
          personStream: person$.stream,
        ),
        act: (cubit) async {
          cubit.initialize();
          await cubit.stream.first;
          person$.add(updatedPerson);
        },
        expect: () => [
          PersonDetailsState(
            gender: person.gender,
            name: person.name,
            surname: person.surname,
            email: person.email,
            dateOfBirth: person.dateOfBirth,
          ),
          PersonDetailsState(
            gender: updatedPerson.gender,
            name: updatedPerson.name,
            surname: updatedPerson.surname,
            email: updatedPerson.email,
            dateOfBirth: updatedPerson.dateOfBirth,
          ),
        ],
        verify: (_) => verify(
          () => personRepository.getPersonById(personId: personId),
        ).called(1),
      );
    },
  );
}
