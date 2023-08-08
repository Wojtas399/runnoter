import '../model/invitation_dto.dart';

InvitationStatus mapInvitationStatusFromString(String invitationStatusStr) =>
    InvitationStatus.values.byName(invitationStatusStr);

String mapInvitationStatusToString(InvitationStatus invitationStatus) =>
    invitationStatus.name;
