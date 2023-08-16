import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseCoachingRequestService extends Mock
    implements FirebaseCoachingRequestService {
  MockFirebaseCoachingRequestService() {
    registerFallbackValue(CoachingRequestDirection.clientToCoach);
  }

  void mockGetCoachingRequestsBySenderId({
    required List<CoachingRequestDto> requests,
  }) {
    when(
      () => getCoachingRequestsBySenderId(
        senderId: any(named: 'senderId'),
        direction: any(named: 'direction'),
      ),
    ).thenAnswer((_) => Stream.value(requests));
  }

  void mockGetCoachingRequestsByReceiverId({
    required List<CoachingRequestDto> requests,
  }) {
    when(
      () => getCoachingRequestsByReceiverId(
        receiverId: any(named: 'receiverId'),
        direction: any(named: 'direction'),
      ),
    ).thenAnswer((_) => Stream.value(requests));
  }

  void mockAddCoachingRequest() {
    when(
      () => addCoachingRequest(
        senderId: any(named: 'senderId'),
        receiverId: any(named: 'receiverId'),
        direction: any(named: 'direction'),
        isAccepted: any(named: 'isAccepted'),
      ),
    ).thenAnswer((_) => Future.value());
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
}
