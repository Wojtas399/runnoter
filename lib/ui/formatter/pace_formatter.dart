import 'package:flutter/material.dart';

import '../../data/entity/activity.dart';
import '../extension/context_extensions.dart';
import '../service/pace_unit_service.dart';
import '../service/utils.dart';
import 'pace_unit_formatter.dart';

extension PaceFormatter on Pace {
  String toUIFormat(BuildContext context) {
    final ConvertedPace convertedPace =
        context.convertPaceFromDefaultUnit(this);
    final String paceUnitStr = context.paceUnit.toUIFormat();
    return switch (convertedPace) {
      ConvertedPaceTime() => _formatPaceTime(convertedPace, paceUnitStr),
      ConvertedPaceDistance() => '${convertedPace.distance} $paceUnitStr',
    };
  }

  String _formatPaceTime(ConvertedPaceTime paceTime, String paceUnitStr) {
    final String minutesStr = twoDigits(paceTime.minutes);
    final String secondsStr = twoDigits(paceTime.seconds);
    return '$minutesStr:$secondsStr $paceUnitStr';
  }
}
