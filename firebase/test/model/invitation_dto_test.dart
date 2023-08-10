import 'package:firebase/model/coaching_request_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String coachingRequestId = 'i1';
  const String senderId = 'u1';
  const String receiverId = 'u2';
  const CoachingRequestStatus status = CoachingRequestStatus.pending;
  const String statusStr = 'pending';

  test(
    'from json, '
    'should map json to dto model',
    () {
      final Map<String, dynamic> json = {
        'senderId': senderId,
        'receiverId': receiverId,
        'status': statusStr,
      };
      const CoachingRequestDto expectedDto = CoachingRequestDto(
        id: coachingRequestId,
        senderId: senderId,
        receiverId: receiverId,
        status: status,
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
        status: status,
      );
      final Map<String, dynamic> expectedJson = {
        'senderId': senderId,
        'receiverId': receiverId,
        'status': statusStr,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );
}
