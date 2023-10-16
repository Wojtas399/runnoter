import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/additional_model/coaching_request.dart';
import 'package:runnoter/data/entity/person.dart';
import 'package:runnoter/data/interface/repository/person_repository.dart';
import 'package:runnoter/data/interface/service/auth_service.dart';
import 'package:runnoter/data/interface/service/coaching_request_service.dart';
import 'package:runnoter/domain/model/coaching_request_with_person.dart';
import 'package:runnoter/domain/use_case/delete_chat_use_case.dart';
import 'package:runnoter/domain/use_case/get_received_coaching_requests_with_sender_info_use_case.dart';
import 'package:runnoter/domain/use_case/get_sent_coaching_requests_with_receiver_info_use_case.dart';
import 'package:runnoter/domain/use_case/load_chat_id_use_case.dart';
import 'package:runnoter/ui/cubit/clients/clients_cubit.dart';
import 'package:runnoter/ui/model/cubit_status.dart';

import '../../../creators/person_creator.dart';
import '../../../mock/domain/repository/mock_person_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';
import '../../../mock/domain/service/mock_coaching_request_service.dart';
import '../../../mock/domain/use_case/mock_delete_chat_use_case.dart';
import '../../../mock/domain/use_case/mock_get_received_coaching_requests_with_sender_info_use_case.dart';
import '../../../mock/domain/use_case/mock_get_sent_coaching_requests_with_receiver_info_use_case.dart';
import '../../../mock/domain/use_case/mock_load_chat_id_use_case.dart';

void main() {
  final authService = MockAuthService();
  final coachingRequestService = MockCoachingRequestService();
  final personRepository = MockPersonRepository();
  final getSentCoachingRequestsWithReceiverInfoUseCase =
      MockGetSentCoachingRequestsWithReceiverInfoUseCase();
  final getReceivedCoachingRequestsWithSenderInfoUseCase =
      MockGetReceivedCoachingRequestsWithSenderInfoUseCase();
  final loadChatIdUseCase = MockLoadChatIdUseCase();
  final deleteChatUseCase = MockDeleteChatUseCase();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerFactory<CoachingRequestService>(
      () => coachingRequestService,
    );
    GetIt.I.registerSingleton<PersonRepository>(personRepository);
    GetIt.I.registerFactory<LoadChatIdUseCase>(() => loadChatIdUseCase);
    GetIt.I.registerFactory<GetSentCoachingRequestsWithReceiverInfoUseCase>(
      () => getSentCoachingRequestsWithReceiverInfoUseCase,
    );
    GetIt.I.registerFactory<GetReceivedCoachingRequestsWithSenderInfoUseCase>(
      () => getReceivedCoachingRequestsWithSenderInfoUseCase,
    );
    GetIt.I.registerFactory<DeleteChatUseCase>(() => deleteChatUseCase);
  });

  tearDown(() {
    reset(authService);
    reset(coachingRequestService);
    reset(personRepository);
    reset(loadChatIdUseCase);
    reset(getSentCoachingRequestsWithReceiverInfoUseCase);
    reset(getReceivedCoachingRequestsWithSenderInfoUseCase);
    reset(deleteChatUseCase);
  });

  group(
    'initialize, ',
    () {
      final List<Person> clients = [
        createPerson(id: 'p1', name: 'first client'),
        createPerson(id: 'p2', name: 'second client'),
      ];
      final List<Person> updatedClients = [
        ...clients,
        createPerson(id: 'p3', name: 'third client'),
      ];
      final List<CoachingRequestWithPerson> sentRequests = [
        CoachingRequestWithPerson(id: 'r1', person: createPerson(id: 'p4')),
      ];
      final List<CoachingRequestWithPerson> updatedSentRequests = [
        ...sentRequests,
        CoachingRequestWithPerson(id: 'r2', person: createPerson(id: 'p5')),
      ];
      final List<CoachingRequestWithPerson> receivedRequests = [
        CoachingRequestWithPerson(id: 'r3', person: createPerson(id: 'p6')),
      ];
      final List<CoachingRequestWithPerson> updatedReceivedRequests = [
        ...sentRequests,
        CoachingRequestWithPerson(id: 'r4', person: createPerson(id: 'p7')),
      ];
      final sentRequests$ = StreamController<List<CoachingRequestWithPerson>>()
        ..add(sentRequests);
      final receivedRequests$ =
          StreamController<List<CoachingRequestWithPerson>>()
            ..add(receivedRequests);
      final clients$ = StreamController<List<Person>>()..add(clients);

      blocTest(
        'should listen to connectivity status, '
        'should listen to clients, sent requests received requests',
        build: () => ClientsCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          getSentCoachingRequestsWithReceiverInfoUseCase.mock(
            requests$: sentRequests$.stream,
          );
          getReceivedCoachingRequestsWithSenderInfoUseCase.mock(
            requests$: receivedRequests$.stream,
          );
          personRepository.mockGetPersonsByCoachId(
            personsStream: clients$.stream,
          );
        },
        act: (cubit) async {
          cubit.initialize();
          await cubit.stream.first;
          sentRequests$.add(updatedSentRequests);
          await cubit.stream.first;
          receivedRequests$.add(updatedReceivedRequests);
          await cubit.stream.first;
          clients$.add(updatedClients);
        },
        expect: () => [
          ClientsState(
            status: const CubitStatusComplete(),
            sentRequests: sentRequests,
            receivedRequests: receivedRequests,
            clients: clients,
          ),
          ClientsState(
              status: const CubitStatusComplete(),
              sentRequests: updatedSentRequests,
              receivedRequests: receivedRequests,
              clients: clients),
          ClientsState(
            status: const CubitStatusComplete(),
            sentRequests: updatedSentRequests,
            receivedRequests: updatedReceivedRequests,
            clients: clients,
          ),
          ClientsState(
            status: const CubitStatusComplete(),
            sentRequests: updatedSentRequests,
            receivedRequests: updatedReceivedRequests,
            clients: updatedClients,
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => getSentCoachingRequestsWithReceiverInfoUseCase.execute(
              senderId: loggedUserId,
              requestDirection: CoachingRequestDirection.coachToClient,
              requestStatuses: SentCoachingRequestStatuses.onlyUnaccepted,
            ),
          ).called(1);
          verify(
            () => getReceivedCoachingRequestsWithSenderInfoUseCase.execute(
              receiverId: loggedUserId,
              requestDirection: CoachingRequestDirection.clientToCoach,
              requestStatuses: ReceivedCoachingRequestStatuses.onlyUnaccepted,
            ),
          ).called(1);
          verify(
            () => personRepository.getPersonsByCoachId(coachId: loggedUserId),
          ).called(1);
        },
      );
    },
  );

  blocTest(
    'acceptRequest, '
    'logged user does not exist, '
    'should emit no logged user status',
    build: () => ClientsCubit(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (cubit) => cubit.acceptRequest('r1'),
    expect: () => [
      const ClientsState(status: CubitStatusNoLoggedUser()),
    ],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'acceptRequest, '
    'should refresh client in repo and load its data, '
    'if client does not have a coach should call coaching request service method '
    'to update request with isAccepted param set as true and '
    "should assign logged user id to coach id of request's sender",
    build: () => ClientsCubit(
      initialState: ClientsState(
        status: const CubitStatusComplete(),
        receivedRequests: [
          CoachingRequestWithPerson(
            id: 'r1',
            person: createPerson(id: 'p1'),
          ),
          CoachingRequestWithPerson(
            id: 'r2',
            person: createPerson(id: 'p2'),
          ),
        ],
      ),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      personRepository.mockRefreshPersonById();
      personRepository.mockGetPersonById(person: createPerson(id: 'p1'));
      coachingRequestService.mockUpdateCoachingRequest();
      personRepository.mockUpdateCoachIdOfPerson();
    },
    act: (cubit) => cubit.acceptRequest('r1'),
    expect: () => [
      ClientsState(
        status: const CubitStatusLoading(),
        receivedRequests: [
          CoachingRequestWithPerson(
            id: 'r1',
            person: createPerson(id: 'p1'),
          ),
          CoachingRequestWithPerson(
            id: 'r2',
            person: createPerson(id: 'p2'),
          ),
        ],
      ),
      ClientsState(
        status: const CubitStatusComplete<ClientsCubitInfo>(
          info: ClientsCubitInfo.requestAccepted,
        ),
        receivedRequests: [
          CoachingRequestWithPerson(
            id: 'r1',
            person: createPerson(id: 'p1'),
          ),
          CoachingRequestWithPerson(
            id: 'r2',
            person: createPerson(id: 'p2'),
          ),
        ],
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => personRepository.refreshPersonById(personId: 'p1'),
      ).called(1);
      verify(() => personRepository.getPersonById(personId: 'p1')).called(1);
      verify(
        () => coachingRequestService.updateCoachingRequest(
          requestId: 'r1',
          isAccepted: true,
        ),
      ).called(1);
      verify(
        () => personRepository.updateCoachIdOfPerson(
          personId: 'p1',
          coachId: loggedUserId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'acceptRequest, '
    'should refresh client in repo and load its data, '
    'if client already has a coach should emit error status with '
    'clientAlreadyHasCoach error',
    build: () => ClientsCubit(
      initialState: ClientsState(
        status: const CubitStatusComplete(),
        receivedRequests: [
          CoachingRequestWithPerson(
            id: 'r1',
            person: createPerson(id: 'p1'),
          ),
          CoachingRequestWithPerson(
            id: 'r2',
            person: createPerson(id: 'p2'),
          ),
        ],
      ),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      personRepository.mockRefreshPersonById();
      personRepository.mockGetPersonById(
        person: createPerson(id: 'p1', coachId: 'c1'),
      );
    },
    act: (cubit) => cubit.acceptRequest('r1'),
    expect: () => [
      ClientsState(
        status: const CubitStatusLoading(),
        receivedRequests: [
          CoachingRequestWithPerson(
            id: 'r1',
            person: createPerson(id: 'p1'),
          ),
          CoachingRequestWithPerson(
            id: 'r2',
            person: createPerson(id: 'p2'),
          ),
        ],
      ),
      ClientsState(
        status: const CubitStatusError<ClientsCubitError>(
          error: ClientsCubitError.personAlreadyHasCoach,
        ),
        receivedRequests: [
          CoachingRequestWithPerson(
            id: 'r1',
            person: createPerson(id: 'p1'),
          ),
          CoachingRequestWithPerson(
            id: 'r2',
            person: createPerson(id: 'p2'),
          ),
        ],
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => personRepository.refreshPersonById(personId: 'p1'),
      ).called(1);
      verify(() => personRepository.getPersonById(personId: 'p1')).called(1);
    },
  );

  blocTest(
    'deleteRequest, '
    "should call coaching request service's method to delete request and should emit requestDeleted info",
    build: () => ClientsCubit(),
    setUp: () => coachingRequestService.mockDeleteCoachingRequest(),
    act: (cubit) => cubit.deleteRequest('r1'),
    expect: () => [
      const ClientsState(status: CubitStatusLoading()),
      const ClientsState(
        status: CubitStatusComplete<ClientsCubitInfo>(
          info: ClientsCubitInfo.requestDeleted,
        ),
      ),
    ],
    verify: (_) => verify(
      () => coachingRequestService.deleteCoachingRequest(requestId: 'r1'),
    ).called(1),
  );

  blocTest(
    'openChatWithClient, '
    'should call use case to load chat id and should emit loaded id',
    build: () => ClientsCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      loadChatIdUseCase.mock(chatId: 'c1');
    },
    act: (cubit) => cubit.openChatWithClient('cl1'),
    expect: () => [
      const ClientsState(status: CubitStatusLoading()),
      const ClientsState(status: CubitStatusComplete(), selectedChatId: 'c1'),
    ],
    verify: (_) => verify(
      () => loadChatIdUseCase.execute(user1Id: loggedUserId, user2Id: 'cl1'),
    ).called(1),
  );

  blocTest(
    'deleteClient, '
    'logged user does not exist, '
    'should do nothing',
    build: () => ClientsCubit(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (cubit) => cubit.deleteClient('c1'),
    expect: () => [],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'deleteClient, '
    'should call person repository method to update person with coachId set as null, '
    'should call coaching request service method to delete request between users, '
    'if chat exists should call use case to delete chat, '
    'should emit clientDeleted info',
    build: () => ClientsCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      personRepository.mockUpdateCoachIdOfPerson();
      coachingRequestService.mockDeleteCoachingRequestBetweenUsers();
      loadChatIdUseCase.mock(chatId: 'chat1');
      deleteChatUseCase.mock();
    },
    act: (cubit) => cubit.deleteClient('c1'),
    expect: () => [
      const ClientsState(status: CubitStatusLoading()),
      const ClientsState(
        status: CubitStatusComplete<ClientsCubitInfo>(
          info: ClientsCubitInfo.clientDeleted,
        ),
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => personRepository.updateCoachIdOfPerson(
          personId: 'c1',
          coachId: null,
        ),
      ).called(1);
      verify(
        () => coachingRequestService.deleteCoachingRequestBetweenUsers(
          user1Id: loggedUserId,
          user2Id: 'c1',
        ),
      ).called(1);
      verify(() => deleteChatUseCase.execute(chatId: 'chat1')).called(1);
    },
  );

  blocTest(
    'deleteClient, '
    'should call person repository method to update person with coachId set as null, '
    'should call coaching request service method to delete request between users, '
    'if chat does not exist should not call use case to delete chat, '
    'should emit clientDeleted info',
    build: () => ClientsCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      personRepository.mockUpdateCoachIdOfPerson();
      coachingRequestService.mockDeleteCoachingRequestBetweenUsers();
      loadChatIdUseCase.mock();
    },
    act: (cubit) => cubit.deleteClient('c1'),
    expect: () => [
      const ClientsState(status: CubitStatusLoading()),
      const ClientsState(
        status: CubitStatusComplete<ClientsCubitInfo>(
          info: ClientsCubitInfo.clientDeleted,
        ),
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => personRepository.updateCoachIdOfPerson(
          personId: 'c1',
          coachId: null,
        ),
      ).called(1);
      verify(
        () => coachingRequestService.deleteCoachingRequestBetweenUsers(
          user1Id: loggedUserId,
          user2Id: 'c1',
        ),
      ).called(1);
    },
  );

  blocTest(
    'refreshClients, '
    'clients list is null, '
    'should do nothing',
    build: () => ClientsCubit(),
    act: (cubit) => cubit.refreshClients(),
    expect: () => [],
  );

  blocTest(
    'refreshClients, '
    'clients list is empty, '
    'should do nothing',
    build: () => ClientsCubit(
      initialState: const ClientsState(
        status: CubitStatusComplete(),
        clients: [],
      ),
    ),
    act: (cubit) => cubit.refreshClients(),
    expect: () => [],
  );

  blocTest(
    'refreshClients, '
    'for each client should call person repository method to refresh person',
    build: () => ClientsCubit(
      initialState: ClientsState(
        status: const CubitStatusComplete(),
        clients: [createPerson(id: 'c1'), createPerson(id: 'c2')],
      ),
    ),
    setUp: () => personRepository.mockRefreshPersonById(),
    act: (cubit) => cubit.refreshClients(),
    expect: () => [],
    verify: (_) {
      verify(
        () => personRepository.refreshPersonById(personId: 'c1'),
      ).called(1);
      verify(
        () => personRepository.refreshPersonById(personId: 'c2'),
      ).called(1);
    },
  );

  group(
    'checkIfClientIsStillClient',
    () {
      bool? result;

      blocTest(
        'logged user does not exist, '
        'should emit no logged user status and return false',
        build: () => ClientsCubit(),
        setUp: () => authService.mockGetLoggedUserId(),
        act: (cubit) async {
          result = await cubit.checkIfClientIsStillClient('c1');
        },
        expect: () => [
          const ClientsState(status: CubitStatusNoLoggedUser()),
        ],
        verify: (_) {
          expect(result, false);
          verify(() => authService.loggedUserId$).called(1);
        },
      );
    },
  );

  group(
    'checkIfClientIsStillClient',
    () {
      bool? result;

      blocTest(
        'should call person repository method to refresh client, '
        'should load client from repository, '
        'if coach id of client is different than logged user id should emit '
        'error status with clientIsNoLongerClient error and should return false',
        build: () => ClientsCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          personRepository.mockRefreshPersonById();
          personRepository.mockGetPersonById(
            person: createPerson(coachId: 'u2'),
          );
        },
        act: (cubit) async {
          result = await cubit.checkIfClientIsStillClient('c1');
        },
        expect: () => [
          const ClientsState(
            status: CubitStatusError(
              error: ClientsCubitError.clientIsNoLongerClient,
            ),
          ),
        ],
        verify: (_) {
          expect(result, false);
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => personRepository.refreshPersonById(personId: 'c1'),
          ).called(1);
          verify(
            () => personRepository.getPersonById(personId: 'c1'),
          ).called(1);
        },
      );
    },
  );

  group(
    'checkIfClientIsStillClient',
    () {
      bool? result;

      blocTest(
        'should call person repository method to refresh client, '
        'should load client from repository, '
        'if coach id of client is equal to logged user id should return true',
        build: () => ClientsCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          personRepository.mockRefreshPersonById();
          personRepository.mockGetPersonById(
            person: createPerson(coachId: loggedUserId),
          );
        },
        act: (cubit) async {
          result = await cubit.checkIfClientIsStillClient('c1');
        },
        expect: () => [],
        verify: (_) {
          expect(result, true);
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => personRepository.refreshPersonById(personId: 'c1'),
          ).called(1);
          verify(
            () => personRepository.getPersonById(personId: 'c1'),
          ).called(1);
        },
      );
    },
  );
}
