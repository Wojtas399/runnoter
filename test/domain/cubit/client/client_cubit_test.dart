import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/entity/person.dart';
import 'package:runnoter/data/entity/user.dart';
import 'package:runnoter/domain/cubit/client/client_cubit.dart';
import 'package:runnoter/domain/repository/person_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';
import 'package:runnoter/domain/use_case/load_chat_id_use_case.dart';

import '../../../creators/person_creator.dart';
import '../../../mock/domain/repository/mock_person_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';
import '../../../mock/domain/use_case/mock_load_chat_id_use_case.dart';

void main() {
  final authService = MockAuthService();
  final personRepository = MockPersonRepository();
  final loadChatIdUseCase = MockLoadChatIdUseCase();
  const String clientId = 'c1';

  ClientCubit createCubit() => ClientCubit(clientId: clientId);

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerSingleton<PersonRepository>(personRepository);
    GetIt.I.registerFactory<LoadChatIdUseCase>(() => loadChatIdUseCase);
  });

  tearDown(() {
    reset(authService);
    reset(personRepository);
    reset(loadChatIdUseCase);
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
        build: () => createCubit(),
        setUp: () => personRepository.mockGetPersonById(
          personStream: client$.stream,
        ),
        act: (cubit) async {
          cubit.initialize();
          await cubit.stream.first;
          client$.add(updatedClient);
        },
        expect: () => [
          ClientState(
            name: client.name,
            surname: client.surname,
          ),
          ClientState(
            name: updatedClient.name,
            surname: updatedClient.surname,
          ),
        ],
        verify: (_) => verify(
          () => personRepository.getPersonById(personId: clientId),
        ).called(1),
      );
    },
  );

  test(
    'load chat id, '
    'should call use case to load chat id and should return loaded chat id',
    () async {
      const String loggedUserId = 'u1';
      const String expectedChatId = 'chat1';
      authService.mockGetLoggedUserId(userId: loggedUserId);
      loadChatIdUseCase.mock(chatId: expectedChatId);
      final cubit = createCubit();

      final String? chatId = await cubit.loadChatId();

      expect(chatId, expectedChatId);
      verify(
        () => loadChatIdUseCase.execute(
          user1Id: loggedUserId,
          user2Id: clientId,
        ),
      ).called(1);
    },
  );

  test(
    'load chat id, '
    'logged user does not exist, '
    'should return null',
    () async {
      authService.mockGetLoggedUserId();
      final cubit = createCubit();

      final String? chatId = await cubit.loadChatId();

      expect(chatId, null);
    },
  );
}
