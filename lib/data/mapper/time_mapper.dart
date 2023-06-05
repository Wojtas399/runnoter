import 'package:firebase/firebase.dart';

import '../../domain/entity/competition.dart';

Time mapTimeFromDto(TimeDto timeDto) => Time(
      hour: timeDto.hour,
      minute: timeDto.minute,
      second: timeDto.second,
    );

TimeDto mapTimeToDto(Time time) => TimeDto(
      hour: time.hour,
      minute: time.minute,
      second: time.second,
    );
