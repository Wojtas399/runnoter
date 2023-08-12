import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/clients/clients_bloc.dart';
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

  blocTest(
    'initialize, '
    'should emit clients and sent requests',
    build: () => ClientsBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      personRepository.mockGetPersonsByCoachId(
        persons: [createPerson(id: 'u2'), createPerson(id: 'u3')],
      );
      coachingRequestService.mockGetCoachingRequestsBySenderId(
        requests: [
          createCoachingRequest(id: 'r1', receiverId: 'u4', isAccepted: false),
          createCoachingRequest(id: 'r2', receiverId: 'u5', isAccepted: false),
          createCoachingRequest(id: 'r3', receiverId: 'u6', isAccepted: true),
        ],
      );
      when(
        () => personRepository.getPersonById(personId: 'u4'),
      ).thenAnswer((_) => Stream.value(createPerson(id: 'u4')));
      when(
        () => personRepository.getPersonById(personId: 'u5'),
      ).thenAnswer((_) => Stream.value(createPerson(id: 'u5')));
      personRepository.mockRefreshPersonsByCoachId();
    },
    act: (bloc) => bloc.add(const ClientsEventInitialize()),
    expect: () => [
      ClientsState(
        status: const BlocStatusComplete(),
        sentRequests: [
          SentCoachingRequest(
            requestId: 'r1',
            receiver: createPerson(id: 'u4'),
          ),
          SentCoachingRequest(
            requestId: 'r2',
            receiver: createPerson(id: 'u5'),
          ),
        ],
        clients: [createPerson(id: 'u2'), createPerson(id: 'u3')],
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => personRepository.getPersonsByCoachId(coachId: loggedUserId),
      ).called(1);
      verify(
        () => coachingRequestService.getCoachingRequestsBySenderId(
          senderId: loggedUserId,
        ),
      ).called(1);
      verify(() => personRepository.getPersonById(personId: 'u4')).called(1);
      verify(() => personRepository.getPersonById(personId: 'u5')).called(1);
      verify(
        () => personRepository.refreshPersonsByCoachId(coachId: loggedUserId),
      ).called(1);
    },
  );

  blocTest(
    'initialize, '
    'there are no sent requests, '
    'should emit sent requests param as empty array',
    build: () => ClientsBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      personRepository.mockGetPersonsByCoachId(
        persons: [createPerson(id: 'u2'), createPerson(id: 'u3')],
      );
      coachingRequestService.mockGetCoachingRequestsBySenderId(requests: []);
      personRepository.mockRefreshPersonsByCoachId();
    },
    act: (bloc) => bloc.add(const ClientsEventInitialize()),
    expect: () => [
      ClientsState(
        status: const BlocStatusComplete(),
        sentRequests: const [],
        clients: [createPerson(id: 'u2'), createPerson(id: 'u3')],
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => personRepository.getPersonsByCoachId(coachId: loggedUserId),
      ).called(1);
      verify(
        () => coachingRequestService.getCoachingRequestsBySenderId(
          senderId: loggedUserId,
        ),
      ).called(1);
      verify(
        () => personRepository.refreshPersonsByCoachId(coachId: loggedUserId),
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
