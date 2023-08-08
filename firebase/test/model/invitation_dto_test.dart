import 'package:firebase/model/invitation_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String invitationId = 'i1';
  const String senderId = 'u1';
  const String receiverId = 'u2';
  const InvitationStatus status = InvitationStatus.pending;
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
      const InvitationDto expectedDto = InvitationDto(
        id: invitationId,
        senderId: senderId,
        receiverId: receiverId,
        status: status,
      );

      final InvitationDto dto = InvitationDto.fromJson(
        invitationId: invitationId,
        json: json,
      );

      expect(dto, expectedDto);
    },
  );

  test(
    'to json, '
    'should map dto model to json',
    () {
      const InvitationDto dto = InvitationDto(
        id: invitationId,
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
