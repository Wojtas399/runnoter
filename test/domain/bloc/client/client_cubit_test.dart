import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/cubit/client/client_cubit.dart';
import 'package:runnoter/domain/entity/person.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/repository/person_repository.dart';

import '../../../creators/person_creator.dart';
import '../../../mock/domain/repository/mock_person_repository.dart';

void main() {
  final personRepository = MockPersonRepository();
  const String clientId = 'c1';

  setUpAll(() {
    GetIt.I.registerSingleton<PersonRepository>(personRepository);
  });

  tearDown(() {
    reset(personRepository);
  });

  group(
    'initialize',
    () {
      final Person client = createPerson(
        id: clientId,
        gender: Gender.male,
        name: 'client name',
        surname: 'client surname',
        email: 'client.email@example.com',
      );
      final Person updatedClient = createPerson(
        id: clientId,
        gender: Gender.male,
        name: 'updated client name',
        surname: 'updated client surname',
        email: 'updated client.email@example.com',
      );
      final StreamController<Person?> client$ = StreamController()..add(client);

      blocTest(
        'should set listener of client',
        build: () => ClientCubit(clientId: clientId),
        setUp: () => personRepository.mockGetPersonById(
          personStream: client$.stream,
        ),
        act: (bloc) async {
          bloc.initialize();
          await bloc.stream.first;
          client$.add(updatedClient);
        },
        expect: () => [
          ClientState(
            status: const BlocStatusComplete(),
            gender: client.gender,
            name: client.name,
            surname: client.surname,
            email: client.email,
          ),
          ClientState(
            status: const BlocStatusComplete(),
            gender: updatedClient.gender,
            name: updatedClient.name,
            surname: updatedClient.surname,
            email: updatedClient.email,
          ),
        ],
        verify: (_) => verify(
          () => personRepository.getPersonById(personId: clientId),
        ).called(1),
      );
    },
  );
}
