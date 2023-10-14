import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/additional_model/coaching_request.dart';
import 'package:runnoter/data/interface/service/coaching_request_service.dart';

class MockCoachingRequestService extends Mock
    implements CoachingRequestService {
  MockCoachingRequestService() {
    registerFallbackValue(CoachingRequestDirection.clientToCoach);
  }

  void mockGetCoachingRequestsBySenderId({
    List<CoachingRequest>? requests,
    Stream<List<CoachingRequest>>? requestsStream,
  }) {
    when(
      () => getCoachingRequestsBySenderId(
        senderId: any(named: 'senderId'),
        direction: any(named: 'direction'),
      ),
    ).thenAnswer((_) => requestsStream ?? Stream.value(requests ?? []));
  }

  void mockGetCoachingRequestsByReceiverId({
    List<CoachingRequest>? requests,
    Stream<List<CoachingRequest>>? requestsStream,
  }) {
    when(
      () => getCoachingRequestsByReceiverId(
        receiverId: any(named: 'receiverId'),
        direction: any(named: 'direction'),
      ),
    ).thenAnswer((_) => requestsStream ?? Stream.value(requests ?? []));
  }

  void mockAddCoachingRequest({Object? throwable}) {
    if (throwable != null) {
      when(_addCoachingRequestCall).thenThrow(throwable);
    } else {
      when(_addCoachingRequestCall).thenAnswer((_) => Future.value());
    }
  }

  void mockUpdateCoachingRequest() {
    when(
      () => updateCoachingRequest(
        requestId: any(named: 'requestId'),
        isAccepted: any(named: 'isAccepted'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockDeleteCoachingRequest() {
    when(
      () => deleteCoachingRequest(
        requestId: any(named: 'requestId'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockDeleteCoachingRequestsByUserId() {
    when(
      () => deleteCoachingRequestsByUserId(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockDeleteCoachingRequestBetweenUsers() {
    when(
      () => deleteCoachingRequestBetweenUsers(
        user1Id: any(named: 'user1Id'),
        user2Id: any(named: 'user2Id'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  Future<void> _addCoachingRequestCall() => addCoachingRequest(
        senderId: any(named: 'senderId'),
        receiverId: any(named: 'receiverId'),
        direction: any(named: 'direction'),
        isAccepted: any(named: 'isAccepted'),
      );
}
