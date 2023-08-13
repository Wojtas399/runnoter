import 'package:firebase/model/coaching_request_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String coachingRequestId = 'i1';
  const String senderId = 'u1';
  const String receiverId = 'u2';
  const CoachingRequestDirection direction =
      CoachingRequestDirection.clientToCoach;
  const String directionStr = 'clientToCoach';
  const bool isAccepted = false;

  test(
    'from json, '
    'should map json to dto model',
    () {
      final Map<String, dynamic> json = {
        'senderId': senderId,
        'receiverId': receiverId,
        'direction': directionStr,
        'isAccepted': isAccepted,
      };
      const CoachingRequestDto expectedDto = CoachingRequestDto(
        id: coachingRequestId,
        senderId: senderId,
        receiverId: receiverId,
        direction: direction,
        isAccepted: isAccepted,
      );

      final CoachingRequestDto dto = CoachingRequestDto.fromJson(
        coachingRequestId: coachingRequestId,
        json: json,
      );

      expect(dto, expectedDto);
    },
  );

  test(
    'to json, '
    'should map dto model to json',
    () {
      const CoachingRequestDto dto = CoachingRequestDto(
        id: coachingRequestId,
        senderId: senderId,
        receiverId: receiverId,
        direction: direction,
        isAccepted: isAccepted,
      );
      final Map<String, dynamic> expectedJson = {
        'senderId': senderId,
        'receiverId': receiverId,
        'direction': directionStr,
        'isAccepted': isAccepted,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );
}
