import 'package:firebase/firebase.dart';

import '../service/coaching_request/coaching_request_service.dart';
import 'coaching_request_direction_mapper.dart';

CoachingRequest mapCoachingRequestFromDto(
  CoachingRequestDto coachingRequestDto,
) =>
    CoachingRequest(
      id: coachingRequestDto.id,
      senderId: coachingRequestDto.senderId,
      receiverId: coachingRequestDto.receiverId,
      direction: mapCoachingRequestDirectionFromDto(
        coachingRequestDto.direction,
      ),
      isAccepted: coachingRequestDto.isAccepted,
    );
