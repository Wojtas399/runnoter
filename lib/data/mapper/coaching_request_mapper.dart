import 'package:firebase/firebase.dart';

import '../../domain/additional_model/coaching_request.dart';
import 'coaching_request_status_mapper.dart';

CoachingRequest mapCoachingRequestFromDto(
  CoachingRequestDto coachingRequestDto,
) =>
    CoachingRequest(
      id: coachingRequestDto.id,
      senderId: coachingRequestDto.senderId,
      receiverId: coachingRequestDto.receiverId,
      status: mapCoachingRequestStatusFromDto(coachingRequestDto.status),
    );
