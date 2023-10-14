import 'package:rxdart/rxdart.dart';

import '../../data/additional_model/coaching_request.dart';
import '../../data/entity/person.dart';
import '../../data/interface/repository/person_repository.dart';
import '../../data/interface/service/coaching_request_service.dart';
import '../../dependency_injection.dart';
import '../additional_model/coaching_request_with_person.dart';

enum ReceivedCoachingRequestStatuses {
  onlyAccepted,
  onlyUnaccepted,
  acceptedAndUnaccepted
}

class GetReceivedCoachingRequestsWithSenderInfoUseCase {
  final CoachingRequestService _coachingRequestService;
  final PersonRepository _personRepository;

  GetReceivedCoachingRequestsWithSenderInfoUseCase()
      : _coachingRequestService = getIt<CoachingRequestService>(),
        _personRepository = getIt<PersonRepository>();

  Stream<List<CoachingRequestWithPerson>> execute({
    required String receiverId,
    required CoachingRequestDirection requestDirection,
    ReceivedCoachingRequestStatuses requestStatuses =
        ReceivedCoachingRequestStatuses.acceptedAndUnaccepted,
  }) =>
      _coachingRequestService
          .getCoachingRequestsByReceiverId(
            receiverId: receiverId,
            direction: requestDirection,
          )
          .map(
            (sentRequests) => sentRequests.where(
              (req) => switch (requestStatuses) {
                ReceivedCoachingRequestStatuses.acceptedAndUnaccepted => true,
                ReceivedCoachingRequestStatuses.onlyAccepted => req.isAccepted,
                ReceivedCoachingRequestStatuses.onlyUnaccepted =>
                  !req.isAccepted,
              },
            ),
          )
          .map((reqs) => reqs.map(_combineRequestWithSenderInfo))
          .switchMap(
            (reqs$) => reqs$.isEmpty
                ? Stream.value([])
                : Rx.combineLatest(reqs$, (reqs) => reqs),
          );

  Stream<CoachingRequestWithPerson> _combineRequestWithSenderInfo(
    CoachingRequest req,
  ) =>
      _personRepository
          .getPersonById(personId: req.senderId)
          .whereNotNull()
          .map(
            (Person sender) => CoachingRequestWithPerson(
              id: req.id,
              person: sender,
            ),
          );
}
