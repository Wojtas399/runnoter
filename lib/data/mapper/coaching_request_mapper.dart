import 'package:firebase/firebase.dart';

import '../../domain/additional_model/coaching_request.dart';

CoachingRequest mapCoachingRequestFromDto(
  CoachingRequestDto coachingRequestDto,
) =>
    CoachingRequest(
      id: coachingRequestDto.id,
      senderId: coachingRequestDto.senderId,
      receiverId: coachingRequestDto.receiverId,
      isAccepted: coachingRequestDto.isAccepted,
    );
