import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/interface/repository/person_repository.dart';
import 'package:runnoter/data/interface/service/coaching_request_service.dart';
import 'package:runnoter/data/model/person.dart';
import 'package:runnoter/domain/model/coaching_request_with_person.dart';
import 'package:runnoter/domain/use_case/get_sent_coaching_requests_with_receiver_info_use_case.dart';

import '../creators/coaching_request_creator.dart';
import '../creators/person_creator.dart';
import '../mock/data/repository/mock_person_repository.dart';
import '../mock/data/service/mock_coaching_request_service.dart';

void main() {
  final coachingRequestService = MockCoachingRequestService();
  final personRepository = MockPersonRepository();
  late GetSentCoachingRequestsWithReceiverInfoUseCase useCase;

  setUpAll(() {
    GetIt.I.registerFactory<CoachingRequestService>(
      () => coachingRequestService,
    );
    GetIt.I.registerSingleton<PersonRepository>(personRepository);
  });

  setUp(() => useCase = GetSentCoachingRequestsWithReceiverInfoUseCase());

  tearDown(() {
    reset(coachingRequestService);
    reset(personRepository);
  });

  test(
    'only accepted'
    'should emit matching accepted coaching requests with receivers info',
    () {
      const senderId = 's1';
      const requestDirection = CoachingRequestDirection.coachToClient;
      const requestStatuses = SentCoachingRequestStatuses.onlyAccepted;
      final Person receiver2 = createPerson(id: 'p2', name: 'second receiver');
      final Person receiver5 = createPerson(id: 'p5', name: 'fifth receiver');
      final Person updatedReceiver2 = createPerson(
        id: 'p2',
        name: 'updated second receiver',
      );
      final Person updatedReceiver5 = createPerson(
        id: 'p5',
        name: 'updated fifth receiver',
      );
      final List<CoachingRequest> requests = [
        createCoachingRequest(id: 'r1', receiverId: 'p1', isAccepted: false),
        createCoachingRequest(
          id: 'r2',
          receiverId: receiver2.id,
          isAccepted: true,
        ),
        createCoachingRequest(id: 'r3', receiverId: 'p3', isAccepted: false),
      ];
      final List<CoachingRequest> updatedRequests = [
        ...requests,
        createCoachingRequest(id: 'r4', receiverId: 'p4', isAccepted: false),
        createCoachingRequest(
          id: 'r5',
          receiverId: receiver5.id,
          isAccepted: true,
        ),
      ];
      final Stream<List<CoachingRequest>> requests$ =
          Stream.fromIterable([requests, updatedRequests]);
      final Stream<Person> receiver2$ =
          Stream.fromIterable([receiver2, updatedReceiver2]);
      final Stream<Person> receiver5$ =
          Stream.fromIterable([receiver5, updatedReceiver5]);
      coachingRequestService.mockGetCoachingRequestsBySenderId(
        requestsStream: requests$,
      );
      when(
        () => personRepository.getPersonById(personId: receiver2.id),
      ).thenAnswer((_) => receiver2$);
      when(
        () => personRepository.getPersonById(personId: receiver5.id),
      ).thenAnswer((_) => receiver5$);

      final Stream<List<CoachingRequestWithPerson>> result$ = useCase.execute(
        senderId: senderId,
        requestDirection: requestDirection,
        requestStatuses: requestStatuses,
      );

      expect(
        result$,
        emitsInOrder([
          [
            CoachingRequestWithPerson(id: 'r2', person: receiver2),
          ],
          [
            CoachingRequestWithPerson(id: 'r2', person: receiver2),
            CoachingRequestWithPerson(id: 'r5', person: receiver5),
          ],
          [
            CoachingRequestWithPerson(id: 'r2', person: updatedReceiver2),
            CoachingRequestWithPerson(id: 'r5', person: receiver5),
          ],
          [
            CoachingRequestWithPerson(id: 'r2', person: updatedReceiver2),
            CoachingRequestWithPerson(id: 'r5', person: updatedReceiver5),
          ],
        ]),
      );
      verify(
        () => coachingRequestService.getCoachingRequestsBySenderId(
          senderId: senderId,
          direction: requestDirection,
        ),
      ).called(1);
    },
  );

  test(
    'only unaccepted'
    'should emit matching unaccepted coaching requests with receivers info',
    () {
      const senderId = 's1';
      const requestDirection = CoachingRequestDirection.clientToCoach;
      const requestStatuses = SentCoachingRequestStatuses.onlyUnaccepted;
      final Person receiver1 = createPerson(id: 'p1', name: 'first receiver');
      final Person receiver3 = createPerson(id: 'p3', name: 'third receiver');
      final Person receiver4 = createPerson(id: 'p4', name: 'fourth receiver');
      final Person updatedReceiver1 = createPerson(
        id: 'p1',
        name: 'updated first receiver',
      );
      final Person updatedReceiver3 = createPerson(
        id: 'p3',
        name: 'updated third receiver',
      );
      final Person updatedReceiver4 = createPerson(
        id: 'p4',
        name: 'updated fourth receiver',
      );
      final List<CoachingRequest> requests = [
        createCoachingRequest(
          id: 'r1',
          receiverId: receiver1.id,
          isAccepted: false,
        ),
        createCoachingRequest(id: 'r2', receiverId: 'p2', isAccepted: true),
        createCoachingRequest(
          id: 'r3',
          receiverId: receiver3.id,
          isAccepted: false,
        ),
      ];
      final List<CoachingRequest> updatedRequests = [
        ...requests,
        createCoachingRequest(
          id: 'r4',
          receiverId: receiver4.id,
          isAccepted: false,
        ),
        createCoachingRequest(id: 'r5', receiverId: 'p5', isAccepted: true),
      ];
      final Stream<List<CoachingRequest>> requests$ =
          Stream.fromIterable([requests, updatedRequests]);
      final Stream<Person> receiver1$ =
          Stream.fromIterable([receiver1, updatedReceiver1]);
      final Stream<Person> receiver3$ =
          Stream.fromIterable([receiver3, updatedReceiver3]);
      final Stream<Person> receiver4$ =
          Stream.fromIterable([receiver4, updatedReceiver4]);
      coachingRequestService.mockGetCoachingRequestsBySenderId(
        requestsStream: requests$,
      );
      when(
        () => personRepository.getPersonById(personId: receiver1.id),
      ).thenAnswer((_) => receiver1$);
      when(
        () => personRepository.getPersonById(personId: receiver3.id),
      ).thenAnswer((_) => receiver3$);
      when(
        () => personRepository.getPersonById(personId: receiver4.id),
      ).thenAnswer((_) => receiver4$);

      final Stream<List<CoachingRequestWithPerson>> result$ = useCase.execute(
        senderId: senderId,
        requestDirection: requestDirection,
        requestStatuses: requestStatuses,
      );

      expect(
        result$,
        emitsInOrder([
          [
            CoachingRequestWithPerson(id: 'r1', person: receiver1),
            CoachingRequestWithPerson(id: 'r3', person: receiver3),
          ],
          [
            CoachingRequestWithPerson(id: 'r1', person: receiver1),
            CoachingRequestWithPerson(id: 'r3', person: receiver3),
            CoachingRequestWithPerson(id: 'r4', person: receiver4),
          ],
          [
            CoachingRequestWithPerson(id: 'r1', person: updatedReceiver1),
            CoachingRequestWithPerson(id: 'r3', person: receiver3),
            CoachingRequestWithPerson(id: 'r4', person: receiver4),
          ],
          [
            CoachingRequestWithPerson(id: 'r1', person: updatedReceiver1),
            CoachingRequestWithPerson(id: 'r3', person: updatedReceiver3),
            CoachingRequestWithPerson(id: 'r4', person: receiver4),
          ],
          [
            CoachingRequestWithPerson(id: 'r1', person: updatedReceiver1),
            CoachingRequestWithPerson(id: 'r3', person: updatedReceiver3),
            CoachingRequestWithPerson(id: 'r4', person: updatedReceiver4),
          ],
        ]),
      );
      verify(
        () => coachingRequestService.getCoachingRequestsBySenderId(
          senderId: senderId,
          direction: requestDirection,
        ),
      ).called(1);
    },
  );

  test(
    'accepted and unaccepted'
    'should emit matching coaching requests with receivers info',
    () {
      const senderId = 's1';
      const requestDirection = CoachingRequestDirection.coachToClient;
      const requestStatuses = SentCoachingRequestStatuses.acceptedAndUnaccepted;
      final Person receiver1 = createPerson(id: 'p1', name: 'first receiver');
      final Person receiver2 = createPerson(id: 'p2', name: 'second receiver');
      final Person receiver3 = createPerson(id: 'p3', name: 'third receiver');
      final Person receiver4 = createPerson(id: 'p4', name: 'fourth receiver');
      final Person receiver5 = createPerson(id: 'p5', name: 'fifth receiver');
      final Person updatedReceiver1 = createPerson(
        id: 'p1',
        name: 'updated first receiver',
      );
      final Person updatedReceiver2 = createPerson(
        id: 'p2',
        name: 'updated second receiver',
      );
      final Person updatedReceiver3 = createPerson(
        id: 'p3',
        name: 'updated third receiver',
      );
      final Person updatedReceiver4 = createPerson(
        id: 'p4',
        name: 'updated fourth receiver',
      );
      final Person updatedReceiver5 = createPerson(
        id: 'p5',
        name: 'updated fifth receiver',
      );
      final List<CoachingRequest> requests = [
        createCoachingRequest(
          id: 'r1',
          receiverId: receiver1.id,
          isAccepted: false,
        ),
        createCoachingRequest(
          id: 'r2',
          receiverId: receiver2.id,
          isAccepted: true,
        ),
        createCoachingRequest(
          id: 'r3',
          receiverId: receiver3.id,
          isAccepted: false,
        ),
      ];
      final List<CoachingRequest> updatedRequests = [
        ...requests,
        createCoachingRequest(
          id: 'r4',
          receiverId: receiver4.id,
          isAccepted: false,
        ),
        createCoachingRequest(
          id: 'r5',
          receiverId: receiver5.id,
          isAccepted: true,
        ),
      ];
      final Stream<List<CoachingRequest>> requests$ =
          Stream.fromIterable([requests, updatedRequests]);
      final Stream<Person> receiver1$ =
          Stream.fromIterable([receiver1, updatedReceiver1]);
      final Stream<Person> receiver2$ =
          Stream.fromIterable([receiver2, updatedReceiver2]);
      final Stream<Person> receiver3$ =
          Stream.fromIterable([receiver3, updatedReceiver3]);
      final Stream<Person> receiver4$ =
          Stream.fromIterable([receiver4, updatedReceiver4]);
      final Stream<Person> receiver5$ =
          Stream.fromIterable([receiver5, updatedReceiver5]);
      coachingRequestService.mockGetCoachingRequestsBySenderId(
        requestsStream: requests$,
      );
      when(
        () => personRepository.getPersonById(personId: receiver1.id),
      ).thenAnswer((_) => receiver1$);
      when(
        () => personRepository.getPersonById(personId: receiver2.id),
      ).thenAnswer((_) => receiver2$);
      when(
        () => personRepository.getPersonById(personId: receiver3.id),
      ).thenAnswer((_) => receiver3$);
      when(
        () => personRepository.getPersonById(personId: receiver4.id),
      ).thenAnswer((_) => receiver4$);
      when(
        () => personRepository.getPersonById(personId: receiver5.id),
      ).thenAnswer((_) => receiver5$);

      final Stream<List<CoachingRequestWithPerson>> result$ = useCase.execute(
        senderId: senderId,
        requestDirection: requestDirection,
        requestStatuses: requestStatuses,
      );

      expect(
        result$,
        emitsInOrder([
          [
            CoachingRequestWithPerson(id: 'r1', person: receiver1),
            CoachingRequestWithPerson(id: 'r2', person: receiver2),
            CoachingRequestWithPerson(id: 'r3', person: receiver3),
          ],
          [
            CoachingRequestWithPerson(id: 'r1', person: receiver1),
            CoachingRequestWithPerson(id: 'r2', person: receiver2),
            CoachingRequestWithPerson(id: 'r3', person: receiver3),
            CoachingRequestWithPerson(id: 'r4', person: receiver4),
            CoachingRequestWithPerson(id: 'r5', person: receiver5),
          ],
          [
            CoachingRequestWithPerson(id: 'r1', person: updatedReceiver1),
            CoachingRequestWithPerson(id: 'r2', person: receiver2),
            CoachingRequestWithPerson(id: 'r3', person: receiver3),
            CoachingRequestWithPerson(id: 'r4', person: receiver4),
            CoachingRequestWithPerson(id: 'r5', person: receiver5),
          ],
          [
            CoachingRequestWithPerson(id: 'r1', person: updatedReceiver1),
            CoachingRequestWithPerson(id: 'r2', person: updatedReceiver2),
            CoachingRequestWithPerson(id: 'r3', person: receiver3),
            CoachingRequestWithPerson(id: 'r4', person: receiver4),
            CoachingRequestWithPerson(id: 'r5', person: receiver5),
          ],
          [
            CoachingRequestWithPerson(id: 'r1', person: updatedReceiver1),
            CoachingRequestWithPerson(id: 'r2', person: updatedReceiver2),
            CoachingRequestWithPerson(id: 'r3', person: updatedReceiver3),
            CoachingRequestWithPerson(id: 'r4', person: receiver4),
            CoachingRequestWithPerson(id: 'r5', person: receiver5),
          ],
          [
            CoachingRequestWithPerson(id: 'r1', person: updatedReceiver1),
            CoachingRequestWithPerson(id: 'r2', person: updatedReceiver2),
            CoachingRequestWithPerson(id: 'r3', person: updatedReceiver3),
            CoachingRequestWithPerson(id: 'r4', person: updatedReceiver4),
            CoachingRequestWithPerson(id: 'r5', person: receiver5),
          ],
          [
            CoachingRequestWithPerson(id: 'r1', person: updatedReceiver1),
            CoachingRequestWithPerson(id: 'r2', person: updatedReceiver2),
            CoachingRequestWithPerson(id: 'r3', person: updatedReceiver3),
            CoachingRequestWithPerson(id: 'r4', person: updatedReceiver4),
            CoachingRequestWithPerson(id: 'r5', person: updatedReceiver5),
          ],
        ]),
      );
      verify(
        () => coachingRequestService.getCoachingRequestsBySenderId(
          senderId: senderId,
          direction: requestDirection,
        ),
      ).called(1);
    },
  );

  test(
    'should emit empty array if there are no matching requests',
    () {
      coachingRequestService.mockGetCoachingRequestsBySenderId(requests: []);

      final Stream<List<CoachingRequestWithPerson>> requests$ = useCase.execute(
        senderId: 'u1',
        requestDirection: CoachingRequestDirection.coachToClient,
      );

      expect(requests$, emits([]));
    },
  );
}
