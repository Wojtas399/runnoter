import 'package:rxdart/rxdart.dart';

import '../../data/model/person.dart';
import '../../data/repository/person/person_repository.dart';
import '../../data/service/coaching_request/coaching_request_service.dart';
import '../../dependency_injection.dart';
import '../model/coaching_request_with_person.dart';

enum SentCoachingRequestStatuses {
  onlyAccepted,
  onlyUnaccepted,
  acceptedAndUnaccepted
}

class GetSentCoachingRequestsWithReceiverInfoUseCase {
  final CoachingRequestService _coachingRequestService;
  final PersonRepository _personRepository;

  GetSentCoachingRequestsWithReceiverInfoUseCase()
      : _coachingRequestService = getIt<CoachingRequestService>(),
        _personRepository = getIt<PersonRepository>();

  Stream<List<CoachingRequestWithPerson>> execute({
    required String senderId,
    required CoachingRequestDirection requestDirection,
    SentCoachingRequestStatuses requestStatuses =
        SentCoachingRequestStatuses.acceptedAndUnaccepted,
  }) =>
      _coachingRequestService
          .getCoachingRequestsBySenderId(
            senderId: senderId,
            direction: requestDirection,
          )
          .map(
            (sentRequests) => sentRequests.where(
              (req) => switch (requestStatuses) {
                SentCoachingRequestStatuses.acceptedAndUnaccepted => true,
                SentCoachingRequestStatuses.onlyAccepted => req.isAccepted,
                SentCoachingRequestStatuses.onlyUnaccepted => !req.isAccepted,
              },
            ),
          )
          .map((reqs) => reqs.map(_combineRequestWithReceiverInfo))
          .switchMap(
            (reqs$) => reqs$.isEmpty
                ? Stream.value([])
                : Rx.combineLatest(reqs$, (reqs) => reqs),
          );

  Stream<CoachingRequestWithPerson> _combineRequestWithReceiverInfo(
    CoachingRequest req,
  ) =>
      _personRepository
          .getPersonById(personId: req.receiverId)
          .whereNotNull()
          .map(
            (Person receiver) => CoachingRequestWithPerson(
              id: req.id,
              person: receiver,
            ),
          );
}
