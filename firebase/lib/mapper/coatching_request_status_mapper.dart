import '../model/coaching_request_dto.dart';

CoachingRequestStatus mapCoachingRequestStatusFromString(
        String invitationStatusStr) =>
    CoachingRequestStatus.values.byName(invitationStatusStr);

String mapCoachingRequestStatusToString(
        CoachingRequestStatus invitationStatus) =>
    invitationStatus.name;
