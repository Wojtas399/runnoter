part of 'coach_bloc.dart';

abstract class CoachEvent {
  const CoachEvent();
}

class CoachEventInitialize extends CoachEvent {
  const CoachEventInitialize();
}

class CoachEventAcceptRequest extends CoachEvent {
  const CoachEventAcceptRequest();
}

class CoachEventDeclineRequest extends CoachEvent {
  const CoachEventDeclineRequest();
}
