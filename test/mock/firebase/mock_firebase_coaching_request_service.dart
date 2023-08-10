import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseCoachingRequestService extends Mock
    implements FirebaseCoachingRequestService {
  MockFirebaseCoachingRequestService() {
    registerFallbackValue(CoachingRequestStatus.pending);
  }

  void mockGetCoachingRequestsBySenderId({List<CoachingRequestDto>? requests}) {
    when(
      () => getCoachingRequestsBySenderId(
        senderId: any(named: 'senderId'),
      ),
    ).thenAnswer((_) => Stream.value(requests));
  }

  void mockGetCoachingRequestsByReceiverId({
    List<CoachingRequestDto>? requests,
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
        status: any(named: 'status'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockUpdateCoachingRequestStatus() {
    when(
      () => updateCoachingRequestStatus(
        requestId: any(named: 'requestId'),
        status: any(named: 'status'),
      ),
    ).thenAnswer((_) => Future.value(_));
  }

  void mockDeleteCoachingRequest() {
    when(
      () => deleteCoachingRequest(
        requestId: any(named: 'requestId'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
