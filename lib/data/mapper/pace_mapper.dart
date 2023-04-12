import 'package:firebase/firebase.dart';

import '../../domain/model/workout_status.dart';

Pace mapPaceFromFirebase(PaceDto paceDto) {
  return Pace(
    minutes: paceDto.minutes,
    seconds: paceDto.seconds,
  );
}
