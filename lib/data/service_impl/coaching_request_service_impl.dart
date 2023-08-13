import 'package:firebase/firebase.dart' as firebase;

import '../../dependency_injection.dart';
import '../../domain/additional_model/coaching_request.dart';
import '../../domain/additional_model/custom_exception.dart';
import '../../domain/service/coaching_request_service.dart';
import '../mapper/coaching_request_mapper.dart';

class CoachingRequestServiceImpl implements CoachingRequestService {
  final firebase.FirebaseCoachingRequestService _firebaseCoachingRequestService;
  final firebase.FirebaseUserService _firebaseUserService;

  CoachingRequestServiceImpl()
      : _firebaseCoachingRequestService =
            getIt<firebase.FirebaseCoachingRequestService>(),
        _firebaseUserService = getIt<firebase.FirebaseUserService>();

  @override
  Stream<List<CoachingRequest>> getCoachingRequestsBySenderId({
    required String senderId,
  }) =>
      _firebaseCoachingRequestService
          .getCoachingRequestsBySenderId(senderId: senderId)
          .map((dtos) => dtos.map(mapCoachingRequestFromDto).toList());

  @override
  Stream<List<CoachingRequest>> getCoachingRequestsByReceiverId({
    required String receiverId,
  }) =>
      _firebaseCoachingRequestService
          .getCoachingRequestsByReceiverId(receiverId: receiverId)
          .map((dtos) => dtos.map(mapCoachingRequestFromDto).toList());

  @override
  Future<void> addCoachingRequest({
    required String senderId,
    required String receiverId,
    required bool isAccepted,
  }) async {
    final firebase.UserDto? receiverDto =
        await _firebaseUserService.loadUserById(userId: receiverId);
    if (receiverDto?.coachId != null) {
      throw const CoachingRequestException(
        code: CoachingRequestExceptionCode.userAlreadyHasCoach,
      );
    } else {
      await _firebaseCoachingRequestService.addCoachingRequest(
        senderId: senderId,
        receiverId: receiverId,
        isAccepted: isAccepted,
      );
    }
  }

  @override
  Future<void> updateCoachingRequest({
    required String requestId,
    required bool isAccepted,
  }) async {
    await _firebaseCoachingRequestService.updateCoachingRequest(
      requestId: requestId,
      isAccepted: isAccepted,
    );
  }

  @override
  Future<void> deleteCoachingRequest({required String requestId}) async {
    await _firebaseCoachingRequestService.deleteCoachingRequest(
      requestId: requestId,
    );
  }

  @override
  Future<void> deleteCoachingRequestsByReceiverId({
    required String receiverId,
  }) async {
    await _firebaseCoachingRequestService.deleteCoachingRequestsByReceiverId(
      receiverId: receiverId,
    );
  }
}
