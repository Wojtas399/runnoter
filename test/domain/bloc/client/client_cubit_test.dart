import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/common/date_service.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/cubit/client/client_cubit.dart';
import 'package:runnoter/domain/entity/person.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/repository/person_repository.dart';

import '../../../creators/person_creator.dart';
import '../../../mock/common/mock_date_service.dart';
import '../../../mock/domain/repository/mock_person_repository.dart';

void main() {
  final personRepository = MockPersonRepository();
  final dateService = MockDateService();
  const String clientId = 'c1';

  setUpAll(() {
    GetIt.I.registerSingleton<PersonRepository>(personRepository);
    GetIt.I.registerFactory<DateService>(() => dateService);
  });

  tearDown(() {
    reset(personRepository);
    reset(dateService);
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
        dateOfBirth: DateTime(2001, 1, 10),
      );
      final Person updatedClient = createPerson(
        id: clientId,
        gender: Gender.male,
        name: 'updated client name',
        surname: 'updated client surname',
        email: 'updated client.email@example.com',
        dateOfBirth: DateTime(2002, 1, 10),
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
            dateOfBirth: client.dateOfBirth,
          ),
          ClientState(
            status: const BlocStatusComplete(),
            gender: updatedClient.gender,
            name: updatedClient.name,
            surname: updatedClient.surname,
            email: updatedClient.email,
            dateOfBirth: updatedClient.dateOfBirth,
          ),
        ],
        verify: (_) => verify(
          () => personRepository.getPersonById(personId: clientId),
        ).called(1),
      );
    },
  );
}
