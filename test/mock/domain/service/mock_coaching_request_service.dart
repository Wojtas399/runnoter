import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/coaching_request.dart';
import 'package:runnoter/domain/service/coaching_request_service.dart';

class MockCoachingRequestService extends Mock
    implements CoachingRequestService {
  MockCoachingRequestService() {
    registerFallbackValue(CoachingRequestStatus.pending);
  }

  void mockGetCoachingRequestsBySenderId({List<CoachingRequest>? requests}) {
    when(
      () => getCoachingRequestsBySenderId(
        senderId: any(named: 'senderId'),
      ),
    ).thenAnswer((_) => Stream.value(requests));
  }

  void mockGetCoachingRequestsByReceiverId({List<CoachingRequest>? requests}) {
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

  void mockUpdateCoachingRequestStatus() {
    when(
      () => updateCoachingRequestStatus(
        requestId: any(named: 'requestId'),
        status: any(named: 'status'),
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

  Future<void> _addCoachingRequestCall() => addCoachingRequest(
        senderId: any(named: 'senderId'),
        receiverId: any(named: 'receiverId'),
        status: any(named: 'status'),
      );
}
