import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/coaching_request.dart';
import 'package:runnoter/domain/service/coaching_request_service.dart';

class MockCoachingRequestService extends Mock
    implements CoachingRequestService {
  void mockGetCoachingRequestsBySenderId({
    required List<CoachingRequest> requests,
  }) {
    when(
      () => getCoachingRequestsBySenderId(
        senderId: any(named: 'senderId'),
      ),
    ).thenAnswer((_) => Stream.value(requests));
  }

  void mockGetCoachingRequestsByReceiverId({
    required List<CoachingRequest> requests,
  }) {
    when(
      () => getCoachingRequestsByReceiverId(
        receiverId: any(named: 'receiverId'),
      ),
    ).thenAnswer((_) => Stream.value(requests));
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

  void mockDeleteCoachingRequestsByReceiverId() {
    when(
      () => deleteCoachingRequestsByReceiverId(
        receiverId: any(named: 'receiverId'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  Future<void> _addCoachingRequestCall() => addCoachingRequest(
        senderId: any(named: 'senderId'),
        receiverId: any(named: 'receiverId'),
        isAccepted: any(named: 'isAccepted'),
      );
}
