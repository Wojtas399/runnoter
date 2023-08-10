import 'package:firebase/firebase.dart' as firebase;

import '../../dependency_injection.dart';
import '../../domain/additional_model/coaching_request.dart';
import '../../domain/service/coaching_request_service.dart';
import '../mapper/coaching_request_mapper.dart';
import '../mapper/coaching_request_status_mapper.dart';

class CoachingRequestServiceImpl implements CoachingRequestService {
  final firebase.FirebaseInvitationService _firebaseInvitationService;

  CoachingRequestServiceImpl()
      : _firebaseInvitationService =
            getIt<firebase.FirebaseInvitationService>();

  @override
  Stream<List<CoachingRequest>?> getCoachingRequestsBySenderId({
    required String senderId,
  }) =>
      _firebaseInvitationService
          .getInvitationsBySenderId(senderId: senderId)
          .map((dtos) => dtos?.map(mapCoachingRequestFromDto).toList());

  @override
  Stream<List<CoachingRequest>?> getCoachingRequestsByReceiverId({
    required String receiverId,
  }) =>
      _firebaseInvitationService
          .getInvitationsByReceiverId(receiverId: receiverId)
          .map((dtos) => dtos?.map(mapCoachingRequestFromDto).toList());

  @override
  Future<void> addCoachingRequest({
    required String senderId,
    required String receiverId,
    required CoachingRequestStatus status,
  }) async {
    await _firebaseInvitationService.addInvitation(
      senderId: senderId,
      receiverId: receiverId,
      status: mapCoachingRequestStatusToDto(status),
    );
  }

  @override
  Future<void> updateCoachingRequestStatus({
    required String requestId,
    required CoachingRequestStatus status,
  }) async {
    await _firebaseInvitationService.updateInvitationStatus(
      invitationId: requestId,
      status: mapCoachingRequestStatusToDto(status),
    );
  }

  @override
  Future<void> deleteCoachingRequest({required String requestId}) async {
    await _firebaseInvitationService.deleteInvitation(invitationId: requestId);
  }
}
