part of 'profile_coach_bloc.dart';

abstract class ProfileCoachEvent {
  const ProfileCoachEvent();
}

class ProfileCoachEventInitialize extends ProfileCoachEvent {
  const ProfileCoachEventInitialize();
}

class ProfileCoachEventAcceptRequest extends ProfileCoachEvent {
  final String requestId;

  const ProfileCoachEventAcceptRequest({required this.requestId});
}

class ProfileCoachEventDeleteRequest extends ProfileCoachEvent {
  final String requestId;

  const ProfileCoachEventDeleteRequest({required this.requestId});
}

class ProfileCoachEventDeleteCoach extends ProfileCoachEvent {
  const ProfileCoachEventDeleteCoach();
}
