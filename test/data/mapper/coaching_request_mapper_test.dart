import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/coaching_request_mapper.dart';
import 'package:runnoter/domain/additional_model/coaching_request.dart';

void main() {
  const String invitationId = 'i1';
  const String senderId = 'u1';
  const String receiverId = 'u2';
  const firebase.InvitationStatus dtoStatus = firebase.InvitationStatus.pending;
  const CoachingRequestStatus status = CoachingRequestStatus.pending;

  test(
    'map coaching request from dto, '
    'should map dto invitation model to domain coaching request model',
    () {
      const firebase.InvitationDto invitationDto = firebase.InvitationDto(
        id: invitationId,
        senderId: senderId,
        receiverId: receiverId,
        status: dtoStatus,
      );
      const CoachingRequest expectedCoachingRequest = CoachingRequest(
        id: invitationId,
        senderId: senderId,
        receiverId: receiverId,
        status: status,
      );

      final CoachingRequest coachingRequest =
          mapCoachingRequestFromDto(invitationDto);

      expect(coachingRequest, expectedCoachingRequest);
    },
  );
}
