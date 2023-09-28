import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/coaching_request.dart';
import 'package:runnoter/domain/additional_model/coaching_request_with_person.dart';
import 'package:runnoter/domain/entity/person.dart';
import 'package:runnoter/domain/repository/person_repository.dart';
import 'package:runnoter/domain/service/coaching_request_service.dart';
import 'package:runnoter/domain/use_case/get_received_coaching_requests_with_sender_info_use_case.dart';

import '../../creators/coaching_request_creator.dart';
import '../../creators/person_creator.dart';
import '../../mock/domain/repository/mock_person_repository.dart';
import '../../mock/domain/service/mock_coaching_request_service.dart';

void main() {
  final coachingRequestService = MockCoachingRequestService();
  final personRepository = MockPersonRepository();
  late GetReceivedCoachingRequestsWithSenderInfoUseCase useCase;

  setUpAll(() {
    GetIt.I.registerFactory<CoachingRequestService>(
      () => coachingRequestService,
    );
    GetIt.I.registerSingleton<PersonRepository>(personRepository);
  });

  setUp(() => useCase = GetReceivedCoachingRequestsWithSenderInfoUseCase());

  tearDown(() {
    reset(coachingRequestService);
    reset(personRepository);
  });

  test(
    'only accepted'
    'should emit matching accepted coaching requests with senders info',
    () {
      const receiverId = 's1';
      const requestDirection = CoachingRequestDirection.coachToClient;
      const requestStatuses = ReceivedCoachingRequestStatuses.onlyAccepted;
      final Person sender2 = createPerson(id: 'p2', name: 'second sender');
      final Person sender5 = createPerson(id: 'p5', name: 'fifth sender');
      final Person updatedSender2 = createPerson(
        id: 'p2',
        name: 'updated second sender',
      );
      final Person updatedSender5 = createPerson(
        id: 'p5',
        name: 'updated fifth sender',
      );
      final List<CoachingRequest> requests = [
        createCoachingRequest(id: 'r1', senderId: 'p1', isAccepted: false),
        createCoachingRequest(
          id: 'r2',
          senderId: sender2.id,
          isAccepted: true,
        ),
        createCoachingRequest(id: 'r3', senderId: 'p3', isAccepted: false),
      ];
      final List<CoachingRequest> updatedRequests = [
        ...requests,
        createCoachingRequest(id: 'r4', senderId: 'p4', isAccepted: false),
        createCoachingRequest(
          id: 'r5',
          senderId: sender5.id,
          isAccepted: true,
        ),
      ];
      final Stream<List<CoachingRequest>> requests$ =
          Stream.fromIterable([requests, updatedRequests]);
      final Stream<Person> sender2$ =
          Stream.fromIterable([sender2, updatedSender2]);
      final Stream<Person> sender5$ =
          Stream.fromIterable([sender5, updatedSender5]);
      coachingRequestService.mockGetCoachingRequestsByReceiverId(
        requestsStream: requests$,
      );
      when(
        () => personRepository.getPersonById(personId: sender2.id),
      ).thenAnswer((_) => sender2$);
      when(
        () => personRepository.getPersonById(personId: sender5.id),
      ).thenAnswer((_) => sender5$);

      final Stream<List<CoachingRequestWithPerson>> result$ = useCase.execute(
        receiverId: receiverId,
        requestDirection: requestDirection,
        requestStatuses: requestStatuses,
      );

      expect(
        result$,
        emitsInOrder([
          [
            CoachingRequestWithPerson(id: 'r2', person: sender2),
          ],
          [
            CoachingRequestWithPerson(id: 'r2', person: sender2),
            CoachingRequestWithPerson(id: 'r5', person: sender5),
          ],
          [
            CoachingRequestWithPerson(id: 'r2', person: updatedSender2),
            CoachingRequestWithPerson(id: 'r5', person: sender5),
          ],
          [
            CoachingRequestWithPerson(id: 'r2', person: updatedSender2),
            CoachingRequestWithPerson(id: 'r5', person: updatedSender5),
          ],
        ]),
      );
      verify(
        () => coachingRequestService.getCoachingRequestsByReceiverId(
          receiverId: receiverId,
          direction: requestDirection,
        ),
      ).called(1);
    },
  );

  test(
    'only unaccepted'
    'should emit matching unaccepted coaching requests with senders info',
    () {
      const receiverId = 's1';
      const requestDirection = CoachingRequestDirection.clientToCoach;
      const requestStatuses = ReceivedCoachingRequestStatuses.onlyUnaccepted;
      final Person sender1 = createPerson(id: 'p1', name: 'first sender');
      final Person sender3 = createPerson(id: 'p3', name: 'third sender');
      final Person sender4 = createPerson(id: 'p4', name: 'fourth sender');
      final Person updatedSender1 = createPerson(
        id: 'p1',
        name: 'updated first sender',
      );
      final Person updatedSender3 = createPerson(
        id: 'p3',
        name: 'updated third sender',
      );
      final Person updatedSender4 = createPerson(
        id: 'p4',
        name: 'updated fourth sender',
      );
      final List<CoachingRequest> requests = [
        createCoachingRequest(
          id: 'r1',
          senderId: sender1.id,
          isAccepted: false,
        ),
        createCoachingRequest(id: 'r2', senderId: 'p2', isAccepted: true),
        createCoachingRequest(
          id: 'r3',
          senderId: sender3.id,
          isAccepted: false,
        ),
      ];
      final List<CoachingRequest> updatedRequests = [
        ...requests,
        createCoachingRequest(
          id: 'r4',
          senderId: sender4.id,
          isAccepted: false,
        ),
        createCoachingRequest(id: 'r5', senderId: 'p5', isAccepted: true),
      ];
      final Stream<List<CoachingRequest>> requests$ =
          Stream.fromIterable([requests, updatedRequests]);
      final Stream<Person> sender1$ =
          Stream.fromIterable([sender1, updatedSender1]);
      final Stream<Person> sender3$ =
          Stream.fromIterable([sender3, updatedSender3]);
      final Stream<Person> sender4$ =
          Stream.fromIterable([sender4, updatedSender4]);
      coachingRequestService.mockGetCoachingRequestsByReceiverId(
        requestsStream: requests$,
      );
      when(
        () => personRepository.getPersonById(personId: sender1.id),
      ).thenAnswer((_) => sender1$);
      when(
        () => personRepository.getPersonById(personId: sender3.id),
      ).thenAnswer((_) => sender3$);
      when(
        () => personRepository.getPersonById(personId: sender4.id),
      ).thenAnswer((_) => sender4$);

      final Stream<List<CoachingRequestWithPerson>> result$ = useCase.execute(
        receiverId: receiverId,
        requestDirection: requestDirection,
        requestStatuses: requestStatuses,
      );

      expect(
        result$,
        emitsInOrder([
          [
            CoachingRequestWithPerson(id: 'r1', person: sender1),
            CoachingRequestWithPerson(id: 'r3', person: sender3),
          ],
          [
            CoachingRequestWithPerson(id: 'r1', person: sender1),
            CoachingRequestWithPerson(id: 'r3', person: sender3),
            CoachingRequestWithPerson(id: 'r4', person: sender4),
          ],
          [
            CoachingRequestWithPerson(id: 'r1', person: updatedSender1),
            CoachingRequestWithPerson(id: 'r3', person: sender3),
            CoachingRequestWithPerson(id: 'r4', person: sender4),
          ],
          [
            CoachingRequestWithPerson(id: 'r1', person: updatedSender1),
            CoachingRequestWithPerson(id: 'r3', person: updatedSender3),
            CoachingRequestWithPerson(id: 'r4', person: sender4),
          ],
          [
            CoachingRequestWithPerson(id: 'r1', person: updatedSender1),
            CoachingRequestWithPerson(id: 'r3', person: updatedSender3),
            CoachingRequestWithPerson(id: 'r4', person: updatedSender4),
          ],
        ]),
      );
      verify(
        () => coachingRequestService.getCoachingRequestsByReceiverId(
          receiverId: receiverId,
          direction: requestDirection,
        ),
      ).called(1);
    },
  );

  test(
    'accepted and unaccepted'
    'should emit matching coaching requests with senders info',
    () {
      const receiverId = 's1';
      const requestDirection = CoachingRequestDirection.coachToClient;
      const requestStatuses =
          ReceivedCoachingRequestStatuses.acceptedAndUnaccepted;
      final Person sender1 = createPerson(id: 'p1', name: 'first sender');
      final Person sender2 = createPerson(id: 'p2', name: 'second sender');
      final Person sender3 = createPerson(id: 'p3', name: 'third sender');
      final Person sender4 = createPerson(id: 'p4', name: 'fourth sender');
      final Person sender5 = createPerson(id: 'p5', name: 'fifth sender');
      final Person updatedSender1 = createPerson(
        id: 'p1',
        name: 'updated first sender',
      );
      final Person updatedSender2 = createPerson(
        id: 'p2',
        name: 'updated second sender',
      );
      final Person updatedSender3 = createPerson(
        id: 'p3',
        name: 'updated third sender',
      );
      final Person updatedSender4 = createPerson(
        id: 'p4',
        name: 'updated fourth sender',
      );
      final Person updatedSender5 = createPerson(
        id: 'p5',
        name: 'updated fifth sender',
      );
      final List<CoachingRequest> requests = [
        createCoachingRequest(
          id: 'r1',
          senderId: sender1.id,
          isAccepted: false,
        ),
        createCoachingRequest(
          id: 'r2',
          senderId: sender2.id,
          isAccepted: true,
        ),
        createCoachingRequest(
          id: 'r3',
          senderId: sender3.id,
          isAccepted: false,
        ),
      ];
      final List<CoachingRequest> updatedRequests = [
        ...requests,
        createCoachingRequest(
          id: 'r4',
          senderId: sender4.id,
          isAccepted: false,
        ),
        createCoachingRequest(
          id: 'r5',
          senderId: sender5.id,
          isAccepted: true,
        ),
      ];
      final Stream<List<CoachingRequest>> requests$ =
          Stream.fromIterable([requests, updatedRequests]);
      final Stream<Person> sender1$ =
          Stream.fromIterable([sender1, updatedSender1]);
      final Stream<Person> sender2$ =
          Stream.fromIterable([sender2, updatedSender2]);
      final Stream<Person> sender3$ =
          Stream.fromIterable([sender3, updatedSender3]);
      final Stream<Person> sender4$ =
          Stream.fromIterable([sender4, updatedSender4]);
      final Stream<Person> sender5$ =
          Stream.fromIterable([sender5, updatedSender5]);
      coachingRequestService.mockGetCoachingRequestsByReceiverId(
        requestsStream: requests$,
      );
      when(
        () => personRepository.getPersonById(personId: sender1.id),
      ).thenAnswer((_) => sender1$);
      when(
        () => personRepository.getPersonById(personId: sender2.id),
      ).thenAnswer((_) => sender2$);
      when(
        () => personRepository.getPersonById(personId: sender3.id),
      ).thenAnswer((_) => sender3$);
      when(
        () => personRepository.getPersonById(personId: sender4.id),
      ).thenAnswer((_) => sender4$);
      when(
        () => personRepository.getPersonById(personId: sender5.id),
      ).thenAnswer((_) => sender5$);

      final Stream<List<CoachingRequestWithPerson>> result$ = useCase.execute(
        receiverId: receiverId,
        requestDirection: requestDirection,
        requestStatuses: requestStatuses,
      );

      expect(
        result$,
        emitsInOrder([
          [
            CoachingRequestWithPerson(id: 'r1', person: sender1),
            CoachingRequestWithPerson(id: 'r2', person: sender2),
            CoachingRequestWithPerson(id: 'r3', person: sender3),
          ],
          [
            CoachingRequestWithPerson(id: 'r1', person: sender1),
            CoachingRequestWithPerson(id: 'r2', person: sender2),
            CoachingRequestWithPerson(id: 'r3', person: sender3),
            CoachingRequestWithPerson(id: 'r4', person: sender4),
            CoachingRequestWithPerson(id: 'r5', person: sender5),
          ],
          [
            CoachingRequestWithPerson(id: 'r1', person: updatedSender1),
            CoachingRequestWithPerson(id: 'r2', person: sender2),
            CoachingRequestWithPerson(id: 'r3', person: sender3),
            CoachingRequestWithPerson(id: 'r4', person: sender4),
            CoachingRequestWithPerson(id: 'r5', person: sender5),
          ],
          [
            CoachingRequestWithPerson(id: 'r1', person: updatedSender1),
            CoachingRequestWithPerson(id: 'r2', person: updatedSender2),
            CoachingRequestWithPerson(id: 'r3', person: sender3),
            CoachingRequestWithPerson(id: 'r4', person: sender4),
            CoachingRequestWithPerson(id: 'r5', person: sender5),
          ],
          [
            CoachingRequestWithPerson(id: 'r1', person: updatedSender1),
            CoachingRequestWithPerson(id: 'r2', person: updatedSender2),
            CoachingRequestWithPerson(id: 'r3', person: updatedSender3),
            CoachingRequestWithPerson(id: 'r4', person: sender4),
            CoachingRequestWithPerson(id: 'r5', person: sender5),
          ],
          [
            CoachingRequestWithPerson(id: 'r1', person: updatedSender1),
            CoachingRequestWithPerson(id: 'r2', person: updatedSender2),
            CoachingRequestWithPerson(id: 'r3', person: updatedSender3),
            CoachingRequestWithPerson(id: 'r4', person: updatedSender4),
            CoachingRequestWithPerson(id: 'r5', person: sender5),
          ],
          [
            CoachingRequestWithPerson(id: 'r1', person: updatedSender1),
            CoachingRequestWithPerson(id: 'r2', person: updatedSender2),
            CoachingRequestWithPerson(id: 'r3', person: updatedSender3),
            CoachingRequestWithPerson(id: 'r4', person: updatedSender4),
            CoachingRequestWithPerson(id: 'r5', person: updatedSender5),
          ],
        ]),
      );
      verify(
        () => coachingRequestService.getCoachingRequestsByReceiverId(
          receiverId: receiverId,
          direction: requestDirection,
        ),
      ).called(1);
    },
  );
}
