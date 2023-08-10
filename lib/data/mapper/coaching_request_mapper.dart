import 'package:firebase/firebase.dart';

import '../../domain/additional_model/coaching_request.dart';
import 'coaching_request_status_mapper.dart';

CoachingRequest mapCoachingRequestFromDto(InvitationDto invitationDto) =>
    CoachingRequest(
      id: invitationDto.id,
      senderId: invitationDto.senderId,
      receiverId: invitationDto.receiverId,
      status: mapCoachingRequestStatusFromDto(invitationDto.status),
    );
