import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/coaching_request.dart';
import 'package:runnoter/domain/additional_model/coaching_request_short.dart';
import 'package:runnoter/domain/bloc/clients/clients_bloc.dart';
import 'package:runnoter/domain/entity/person.dart';
import 'package:runnoter/domain/repository/person_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';
import 'package:runnoter/domain/service/coaching_request_service.dart';
import 'package:runnoter/domain/use_case/load_chat_id_use_case.dart';

import '../../../creators/coaching_request_creator.dart';
import '../../../creators/person_creator.dart';
import '../../../mock/domain/repository/mock_person_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';
import '../../../mock/domain/service/mock_coaching_request_service.dart';
import '../../../mock/domain/use_case/mock_load_chat_id_use_case.dart';

void main() {
  final authService = MockAuthService();
  final coachingRequestService = MockCoachingRequestService();
  final personRepository = MockPersonRepository();
  final loadChatIdUseCase = MockLoadChatIdUseCase();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerFactory<CoachingRequestService>(
      () => coachingRequestService,
    );
    GetIt.I.registerSingleton<PersonRepository>(personRepository);
    GetIt.I.registerFactory<LoadChatIdUseCase>(() => loadChatIdUseCase);
  });

  tearDown(() {
    reset(authService);
    reset(coachingRequestService);
    reset(personRepository);
    reset(loadChatIdUseCase);
  });

  group(
    'initialize, ',
    () {
      final Person person1 = createPerson(id: 'p1', name: 'nameFirst');
      final Person person2 = createPerson(id: 'p2', name: 'nameSecond');
      final List<Person> clients = [
        createPerson(id: 'p1', name: 'first client'),
        createPerson(id: 'p2', name: 'second client'),
      ];
      final List<Person> updatedClients = [
        ...clients,
        createPerson(id: 'p3', name: 'third client'),
      ];
      StreamController<List<CoachingRequest>> sentRequests$ = StreamController()
        ..add([createCoachingRequest(id: 'r1', receiverId: person1.id)]);
      StreamController<List<CoachingRequest>> receivedRequests$ =
          StreamController()
            ..add([createCoachingRequest(id: 'r2', senderId: person2.id)]);
      final StreamController<List<Person>> clients$ = StreamController()
        ..add(clients);
      final List<CoachingRequestShort> shortSentRequests = [
        CoachingRequestShort(id: 'r1', personToDisplay: person1),
      ];
      final List<CoachingRequestShort> shortReceivedRequests = [
        CoachingRequestShort(id: 'r2', personToDisplay: person2),
      ];

      blocTest(
        'should set listener of clients, sent requests and received requests',
        build: () => ClientsBloc(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          coachingRequestService.mockGetCoachingRequestsBySenderId(
            requestsStream: sentRequests$.stream,
          );
          coachingRequestService.mockGetCoachingRequestsByReceiverId(
            requestsStream: receivedRequests$.stream,
          );
          when(
            () => personRepository.getPersonById(personId: person1.id),
          ).thenAnswer((_) => Stream.value(person1));
          when(
            () => personRepository.getPersonById(personId: person2.id),
          ).thenAnswer((invocation) => Stream.value(person2));
          personRepository.mockGetPersonsByCoachId(
            personsStream: clients$.stream,
          );
        },
        act: (bloc) async {
          bloc.add(const ClientsEventInitialize());
          await bloc.stream.first;
          sentRequests$.add([]);
          await bloc.stream.first;
          receivedRequests$.add([]);
          await bloc.stream.first;
          clients$.add(updatedClients);
        },
        expect: () => [
          ClientsState(
            status: const BlocStatusComplete(),
            sentRequests: shortSentRequests,
            receivedRequests: shortReceivedRequests,
            clients: clients,
          ),
          ClientsState(
              status: const BlocStatusComplete(),
              sentRequests: const [],
              receivedRequests: shortReceivedRequests,
              clients: clients),
          ClientsState(
            status: const BlocStatusComplete(),
            sentRequests: const [],
            receivedRequests: const [],
            clients: clients,
          ),
          ClientsState(
            status: const BlocStatusComplete(),
            sentRequests: const [],
            receivedRequests: const [],
            clients: updatedClients,
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => coachingRequestService.getCoachingRequestsBySenderId(
              senderId: loggedUserId,
              direction: CoachingRequestDirection.coachToClient,
            ),
          ).called(1);
          verify(
            () => coachingRequestService.getCoachingRequestsByReceiverId(
              receiverId: loggedUserId,
              direction: CoachingRequestDirection.clientToCoach,
            ),
          ).called(1);
          verify(
            () => personRepository.getPersonById(personId: person1.id),
          ).called(1);
          verify(
            () => personRepository.getPersonById(personId: person2.id),
          ).called(1);
          verify(
            () => personRepository.getPersonsByCoachId(
              coachId: loggedUserId,
            ),
          ).called(1);
        },
      );
    },
  );

  blocTest(
    'accept request, '
    'logged user does not exist, '
    'should emit no logged user status',
    build: () => ClientsBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const ClientsEventAcceptRequest(requestId: 'r1')),
    expect: () => [
      const ClientsState(status: BlocStatusNoLoggedUser()),
    ],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'accept request, '
    "should call coaching request service's method to update request with isAccepted param set as true, "
    "should assign logged user's id to coach id of request's sender",
    build: () => ClientsBloc(
      state: ClientsState(
        status: const BlocStatusComplete(),
        receivedRequests: [
          CoachingRequestShort(
            id: 'r1',
            personToDisplay: createPerson(id: 'p1'),
          ),
          CoachingRequestShort(
            id: 'r2',
            personToDisplay: createPerson(id: 'p2'),
          ),
        ],
      ),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      coachingRequestService.mockUpdateCoachingRequest();
      personRepository.mockUpdateCoachIdOfPerson();
    },
    act: (bloc) => bloc.add(const ClientsEventAcceptRequest(requestId: 'r1')),
    expect: () => [
      ClientsState(
        status: const BlocStatusLoading(),
        receivedRequests: [
          CoachingRequestShort(
            id: 'r1',
            personToDisplay: createPerson(id: 'p1'),
          ),
          CoachingRequestShort(
            id: 'r2',
            personToDisplay: createPerson(id: 'p2'),
          ),
        ],
      ),
      ClientsState(
        status: const BlocStatusComplete<ClientsBlocInfo>(
          info: ClientsBlocInfo.requestAccepted,
        ),
        receivedRequests: [
          CoachingRequestShort(
            id: 'r1',
            personToDisplay: createPerson(id: 'p1'),
          ),
          CoachingRequestShort(
            id: 'r2',
            personToDisplay: createPerson(id: 'p2'),
          ),
        ],
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
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
    'delete request, '
    "should call coaching request service's method to delete request and should emit requestDeleted info",
    build: () => ClientsBloc(),
    setUp: () => coachingRequestService.mockDeleteCoachingRequest(),
    act: (bloc) => bloc.add(const ClientsEventDeleteRequest(requestId: 'r1')),
    expect: () => [
      const ClientsState(status: BlocStatusLoading()),
      const ClientsState(
        status: BlocStatusComplete<ClientsBlocInfo>(
          info: ClientsBlocInfo.requestDeleted,
        ),
      ),
    ],
    verify: (_) => verify(
      () => coachingRequestService.deleteCoachingRequest(requestId: 'r1'),
    ).called(1),
  );

  blocTest(
    'open chat with client, '
    'should call use case to load chat id and should emit loaded id',
    build: () => ClientsBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      loadChatIdUseCase.mock(chatId: 'c1');
    },
    act: (bloc) => bloc.add(
      const ClientsEventOpenChatWithClient(clientId: 'cl1'),
    ),
    expect: () => [
      const ClientsState(status: BlocStatusLoading()),
      const ClientsState(status: BlocStatusComplete(), selectedChatId: 'c1'),
    ],
    verify: (_) => verify(
      () => loadChatIdUseCase.execute(user1Id: loggedUserId, user2Id: 'cl1'),
    ).called(1),
  );

  blocTest(
    'delete client, '
    "should call person repository's method to update person with coachId set as null and should emit clientDeleted info",
    build: () => ClientsBloc(),
    setUp: () => personRepository.mockUpdateCoachIdOfPerson(),
    act: (bloc) => bloc.add(const ClientsEventDeleteClient(clientId: 'c1')),
    expect: () => [
      const ClientsState(status: BlocStatusLoading()),
      const ClientsState(
        status: BlocStatusComplete<ClientsBlocInfo>(
          info: ClientsBlocInfo.clientDeleted,
        ),
      ),
    ],
    verify: (_) => verify(
      () => personRepository.updateCoachIdOfPerson(
        personId: 'c1',
        coachId: null,
      ),
    ).called(1),
  );
}
