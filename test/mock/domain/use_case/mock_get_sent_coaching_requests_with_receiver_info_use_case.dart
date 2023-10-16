import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/additional_model/coaching_request.dart';
import 'package:runnoter/domain/model/coaching_request_with_person.dart';
import 'package:runnoter/domain/use_case/get_sent_coaching_requests_with_receiver_info_use_case.dart';

class MockGetSentCoachingRequestsWithReceiverInfoUseCase extends Mock
    implements GetSentCoachingRequestsWithReceiverInfoUseCase {
  MockGetSentCoachingRequestsWithReceiverInfoUseCase() {
    registerFallbackValue(CoachingRequestDirection.coachToClient);
    registerFallbackValue(SentCoachingRequestStatuses.acceptedAndUnaccepted);
  }

  void mock({required Stream<List<CoachingRequestWithPerson>> requests$}) {
    when(
      () => execute(
        senderId: any(named: 'senderId'),
        requestDirection: any(named: 'requestDirection'),
        requestStatuses: any(named: 'requestStatuses'),
      ),
    ).thenAnswer((_) => requests$);
  }
}
