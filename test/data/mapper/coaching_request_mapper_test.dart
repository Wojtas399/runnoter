import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/coaching_request_mapper.dart';
import 'package:runnoter/domain/additional_model/coaching_request.dart';

void main() {
  const String coachingRequestId = 'i1';
  const String senderId = 'u1';
  const String receiverId = 'u2';
  const firebase.CoachingRequestDirection dtoDirection =
      firebase.CoachingRequestDirection.clientToCoach;
  const CoachingRequestDirection direction =
      CoachingRequestDirection.clientToCoach;
  const bool isAccepted = false;

  test(
    'map coaching request from dto, '
    'should map dto coachingRequest model to domain coachingRequest model',
    () {
      const firebase.CoachingRequestDto coachingRequestDto =
          firebase.CoachingRequestDto(
        id: coachingRequestId,
        senderId: senderId,
        receiverId: receiverId,
        direction: dtoDirection,
        isAccepted: isAccepted,
      );
      const CoachingRequest expectedCoachingRequest = CoachingRequest(
        id: coachingRequestId,
        senderId: senderId,
        receiverId: receiverId,
        direction: direction,
        isAccepted: isAccepted,
      );

      final CoachingRequest coachingRequest =
          mapCoachingRequestFromDto(coachingRequestDto);

      expect(coachingRequest, expectedCoachingRequest);
    },
  );
}
