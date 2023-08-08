import 'package:firebase/firebase.dart';

import '../../domain/entity/invitation.dart';
import 'invitation_status_mapper.dart';

Invitation mapInvitationFromDto(InvitationDto invitationDto) => Invitation(
      id: invitationDto.id,
      senderId: invitationDto.senderId,
      receiverId: invitationDto.receiverId,
      status: mapInvitationStatusFromDto(invitationDto.status),
    );
