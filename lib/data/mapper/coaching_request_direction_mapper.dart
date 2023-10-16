import 'package:firebase/firebase.dart' as firebase;

import '../interface/service/coaching_request_service.dart';

CoachingRequestDirection mapCoachingRequestDirectionFromDto(
  firebase.CoachingRequestDirection dtoDirection,
) =>
    switch (dtoDirection) {
      firebase.CoachingRequestDirection.clientToCoach =>
        CoachingRequestDirection.clientToCoach,
      firebase.CoachingRequestDirection.coachToClient =>
        CoachingRequestDirection.coachToClient,
    };

firebase.CoachingRequestDirection mapCoachingRequestDirectionToDto(
  CoachingRequestDirection direction,
) =>
    switch (direction) {
      CoachingRequestDirection.clientToCoach =>
        firebase.CoachingRequestDirection.clientToCoach,
      CoachingRequestDirection.coachToClient =>
        firebase.CoachingRequestDirection.coachToClient,
    };
