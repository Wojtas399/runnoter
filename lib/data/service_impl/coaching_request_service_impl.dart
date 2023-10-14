import 'package:firebase/firebase.dart' as firebase;

import '../../dependency_injection.dart';
import '../additional_model/coaching_request.dart';
import '../additional_model/custom_exception.dart';
import '../interface/service/coaching_request_service.dart';
import '../mapper/coaching_request_direction_mapper.dart';
import '../mapper/coaching_request_mapper.dart';

class CoachingRequestServiceImpl implements CoachingRequestService {
  final firebase.FirebaseCoachingRequestService _dbCoachingRequestService;
  final firebase.FirebaseUserService _dbUserService;

  CoachingRequestServiceImpl()
      : _dbCoachingRequestService =
            getIt<firebase.FirebaseCoachingRequestService>(),
        _dbUserService = getIt<firebase.FirebaseUserService>();

  @override
  Stream<List<CoachingRequest>> getCoachingRequestsBySenderId({
    required String senderId,
    required CoachingRequestDirection direction,
  }) =>
      _dbCoachingRequestService
          .getCoachingRequestsBySenderId(
            senderId: senderId,
            direction: mapCoachingRequestDirectionToDto(direction),
          )
          .map((dtos) => dtos.map(mapCoachingRequestFromDto).toList());

  @override
  Stream<List<CoachingRequest>> getCoachingRequestsByReceiverId({
    required String receiverId,
    required CoachingRequestDirection direction,
  }) =>
      _dbCoachingRequestService
          .getCoachingRequestsByReceiverId(
            receiverId: receiverId,
            direction: mapCoachingRequestDirectionToDto(direction),
          )
          .map((dtos) => dtos.map(mapCoachingRequestFromDto).toList());

  @override
  Future<void> addCoachingRequest({
    required String senderId,
    required String receiverId,
    required CoachingRequestDirection direction,
    required bool isAccepted,
  }) async {
    if (direction == CoachingRequestDirection.coachToClient) {
      final firebase.UserDto? receiverDto =
          await _dbUserService.loadUserById(userId: receiverId);
      if (receiverDto?.coachId != null) {
        throw const CoachingRequestException(
          code: CoachingRequestExceptionCode.userAlreadyHasCoach,
        );
      }
    }
    await _dbCoachingRequestService.addCoachingRequest(
      senderId: senderId,
      receiverId: receiverId,
      direction: mapCoachingRequestDirectionToDto(direction),
      isAccepted: isAccepted,
    );
  }

  @override
  Future<void> updateCoachingRequest({
    required String requestId,
    required bool isAccepted,
  }) async {
    await _dbCoachingRequestService.updateCoachingRequest(
      requestId: requestId,
      isAccepted: isAccepted,
    );
  }

  @override
  Future<void> deleteCoachingRequest({required String requestId}) async {
    await _dbCoachingRequestService.deleteCoachingRequest(
      requestId: requestId,
    );
  }

  @override
  Future<void> deleteCoachingRequestsByUserId({required String userId}) async {
    await _dbCoachingRequestService.deleteCoachingRequestsByUserId(
      userId: userId,
    );
  }

  @override
  Future<void> deleteCoachingRequestBetweenUsers({
    required String user1Id,
    required String user2Id,
  }) async {
    await _dbCoachingRequestService.deleteCoachingRequestBetweenUsers(
      user1Id: user1Id,
      user2Id: user2Id,
    );
  }
}
