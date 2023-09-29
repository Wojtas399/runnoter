import 'package:rxdart/rxdart.dart';

import '../../dependency_injection.dart';
import '../additional_model/coaching_request.dart';
import '../additional_model/coaching_request_with_person.dart';
import '../entity/person.dart';
import '../repository/person_repository.dart';
import '../service/coaching_request_service.dart';

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
