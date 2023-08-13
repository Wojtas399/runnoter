import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseCoachingRequestService extends Mock
    implements FirebaseCoachingRequestService {
  void mockGetCoachingRequestsBySenderId({
    required List<CoachingRequestDto> requests,
  }) {
    when(
      () => getCoachingRequestsBySenderId(
        senderId: any(named: 'senderId'),
      ),
    ).thenAnswer((_) => Stream.value(requests));
  }

  void mockGetCoachingRequestsByReceiverId({
    required List<CoachingRequestDto> requests,
  }) {
    when(
      () => getCoachingRequestsByReceiverId(
        receiverId: any(named: 'receiverId'),
      ),
    ).thenAnswer((_) => Stream.value(requests));
  }

  void mockAddCoachingRequest() {
    when(
      () => addCoachingRequest(
        senderId: any(named: 'senderId'),
        receiverId: any(named: 'receiverId'),
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

  void mockDeleteUnacceptedCoachingRequestsByReceiverId() {
    when(
      () => deleteUnacceptedCoachingRequestsByReceiverId(
        receiverId: any(named: 'receiverId'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
