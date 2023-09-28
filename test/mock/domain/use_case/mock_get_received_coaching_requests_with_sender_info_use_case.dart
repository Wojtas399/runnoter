import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/coaching_request.dart';
import 'package:runnoter/domain/additional_model/coaching_request_with_person.dart';
import 'package:runnoter/domain/use_case/get_received_coaching_requests_with_sender_info_use_case.dart';

class MockGetReceivedCoachingRequestsWithSenderInfoUseCase extends Mock
    implements GetReceivedCoachingRequestsWithSenderInfoUseCase {
  MockGetReceivedCoachingRequestsWithSenderInfoUseCase() {
    registerFallbackValue(CoachingRequestDirection.coachToClient);
    registerFallbackValue(
      ReceivedCoachingRequestStatuses.acceptedAndUnaccepted,
    );
  }

  void mock({required Stream<List<CoachingRequestWithPerson>> requests$}) {
    when(
      () => execute(
        receiverId: any(named: 'receiverId'),
        requestDirection: any(named: 'requestDirection'),
        requestStatuses: any(named: 'requestStatuses'),
      ),
    ).thenAnswer((_) => requests$);
  }
}
