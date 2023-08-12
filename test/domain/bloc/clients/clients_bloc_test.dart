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
    'should emit clients and invited persons',
    build: () => ClientsBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      personRepository.mockGetPersonsByCoachId(
        persons: [createPerson(id: 'u2'), createPerson(id: 'u3')],
      );
      coachingRequestService.mockGetCoachingRequestsBySenderId(
        requests: [
          createCoachingRequest(id: 'r1', receiverId: 'u4'),
          createCoachingRequest(id: 'r2', receiverId: 'u5'),
        ],
      );
      when(
        () => personRepository.getPersonById(personId: 'u4'),
      ).thenAnswer((_) => Stream.value(createPerson(id: 'u4')));
      when(
        () => personRepository.getPersonById(personId: 'u5'),
      ).thenAnswer((_) => Stream.value(createPerson(id: 'u5')));
    },
    act: (bloc) => bloc.add(const ClientsEventInitialize()),
    expect: () => [
      ClientsState(
        status: const BlocStatusComplete(),
        invitedPersons: [
          InvitedPerson(
            coachingRequestId: 'r1',
            person: createPerson(id: 'u4'),
          ),
          InvitedPerson(
            coachingRequestId: 'r2',
            person: createPerson(id: 'u5'),
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
    },
  );
}
