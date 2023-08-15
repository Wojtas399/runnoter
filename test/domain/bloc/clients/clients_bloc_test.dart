import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/coaching_request.dart';
import 'package:runnoter/domain/bloc/clients/clients_bloc.dart';
import 'package:runnoter/domain/entity/person.dart';
import 'package:runnoter/domain/repository/person_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';
import 'package:runnoter/domain/service/coaching_request_service.dart';

import '../../../creators/coaching_request_creator.dart';
import '../../../creators/person_creator.dart';
import '../../../mock/domain/repository/mock_person_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';
import '../../../mock/domain/service/mock_coaching_request_service.dart';

void main() {
  final authService = MockAuthService();
  final coachingRequestService = MockCoachingRequestService();
  final personRepository = MockPersonRepository();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerFactory<CoachingRequestService>(
      () => coachingRequestService,
    );
    GetIt.I.registerSingleton<PersonRepository>(personRepository);
  });

  tearDown(() {
    reset(authService);
    reset(coachingRequestService);
    reset(personRepository);
  });

  group(
    'initialize requests, ',
    () {
      final Person person1 = createPerson(id: 'p1', name: 'nameFirst');
      final Person person2 = createPerson(id: 'p2', name: 'nameSecond');
      StreamController<List<CoachingRequest>> sentRequests$ = StreamController()
        ..add([createCoachingRequest(id: 'r1', receiverId: person1.id)]);
      StreamController<List<CoachingRequest>> receivedRequests$ =
          StreamController()
            ..add([createCoachingRequest(id: 'r2', senderId: person2.id)]);
      final List<CoachingRequestDetails> sentRequestDetails = [
        CoachingRequestDetails(id: 'r1', personToDisplay: person1),
      ];
      final List<CoachingRequestDetails> receivedRequestDetails = [
        CoachingRequestDetails(id: 'r2', personToDisplay: person2),
      ];

      blocTest(
        'should set listener of sent and received requests',
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
        },
        act: (bloc) {
          bloc.add(const ClientsEventInitializeRequests());
          sentRequests$.add([]);
          receivedRequests$.add([]);
        },
        expect: () => [
          ClientsState(
            status: const BlocStatusComplete(),
            sentRequests: sentRequestDetails,
            receivedRequests: receivedRequestDetails,
          ),
          ClientsState(
            status: const BlocStatusComplete(),
            sentRequests: const [],
            receivedRequests: receivedRequestDetails,
          ),
          const ClientsState(
            status: BlocStatusComplete(),
            sentRequests: [],
            receivedRequests: [],
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
        },
      );
    },
  );

  group(
    'initialize clients, ',
    () {
      final List<Person> clients = [
        createPerson(id: 'p1', name: 'first client'),
        createPerson(id: 'p2', name: 'second client'),
      ];
      final List<Person> updatedClients = [
        ...clients,
        createPerson(id: 'p3', name: 'third client'),
      ];
      final StreamController<List<Person>> clients$ = StreamController()
        ..add(clients);

      blocTest(
        "should set listener of logged user's clients",
        build: () => ClientsBloc(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          personRepository.mockGetPersonsByCoachId(
            personsStream: clients$.stream,
          );
        },
        act: (bloc) {
          bloc.add(const ClientsEventInitializeClients());
          clients$.add(updatedClients);
        },
        expect: () => [
          ClientsState(
            status: const BlocStatusComplete(),
            clients: clients,
          ),
          ClientsState(
            status: const BlocStatusComplete(),
            clients: updatedClients,
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
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
    'delete client, '
    "should call person repository's method to remove coach of person and should emit clientDeleted info",
    build: () => ClientsBloc(),
    setUp: () => personRepository.mockRemoveCoachOfPerson(),
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
      () => personRepository.removeCoachOfPerson(personId: 'c1'),
    ).called(1),
  );
}
