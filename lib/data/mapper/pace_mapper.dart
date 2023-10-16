import 'package:firebase/firebase.dart';

import '../entity/activity.dart';

Pace mapPaceFromFirebase(PaceDto paceDto) {
  return Pace(
    minutes: paceDto.minutes,
    seconds: paceDto.seconds,
  );
}

PaceDto mapPaceToFirebase(Pace pace) {
  return PaceDto(
    minutes: pace.minutes,
    seconds: pace.seconds,
  );
}
