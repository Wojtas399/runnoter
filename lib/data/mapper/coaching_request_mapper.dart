import 'package:firebase/firebase.dart';

import '../additional_model/coaching_request.dart';
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
