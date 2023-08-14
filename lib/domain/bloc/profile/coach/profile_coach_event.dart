part of 'profile_coach_bloc.dart';

abstract class ProfileCoachEvent {
  const ProfileCoachEvent();
}

class ProfileCoachEventInitializeCoachListener extends ProfileCoachEvent {
  const ProfileCoachEventInitializeCoachListener();
}

class ProfileCoachEventInitializeRequestsListener extends ProfileCoachEvent {
  const ProfileCoachEventInitializeRequestsListener();
}

class ProfileCoachEventRemoveRequestsListener extends ProfileCoachEvent {
  const ProfileCoachEventRemoveRequestsListener();
}

class ProfileCoachEventRequestsUpdated extends ProfileCoachEvent {
  final List<CoachingRequestDetails>? sentRequests;
  final List<CoachingRequestDetails>? receivedRequests;

  const ProfileCoachEventRequestsUpdated({
    required this.sentRequests,
    required this.receivedRequests,
  });
}

class ProfileCoachEventAcceptRequest extends ProfileCoachEvent {
  final String requestId;

  const ProfileCoachEventAcceptRequest({required this.requestId});
}

class ProfileCoachEventDeleteRequest extends ProfileCoachEvent {
  final String requestId;
  final CoachingRequestDirection requestDirection;

  const ProfileCoachEventDeleteRequest({
    required this.requestId,
    required this.requestDirection,
  });
}

class ProfileCoachEventDeleteCoach extends ProfileCoachEvent {
  const ProfileCoachEventDeleteCoach();
}
