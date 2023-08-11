part of 'coach_bloc.dart';

abstract class CoachEvent {
  const CoachEvent();
}

class CoachEventInitialize extends CoachEvent {
  const CoachEventInitialize();
}

class CoachEventAcceptRequest extends CoachEvent {
  final String requestId;

  const CoachEventAcceptRequest({required this.requestId});
}

class CoachEventDeleteRequest extends CoachEvent {
  final String requestId;

  const CoachEventDeleteRequest({required this.requestId});
}
