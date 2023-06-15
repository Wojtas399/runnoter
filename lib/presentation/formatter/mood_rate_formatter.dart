import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/entity/run_status.dart';

extension MoodRateFormatter on MoodRate {
  String toUIFormat(BuildContext context) {
    final str = Str.of(context);
    return switch (this) {
      MoodRate.mr1 => '1 - ${str.moodRate1}',
      MoodRate.mr2 => '2 - ${str.moodRate2}',
      MoodRate.mr3 => '3 - ${str.moodRate3}',
      MoodRate.mr4 => '4 - ${str.moodRate4}',
      MoodRate.mr5 => '5 - ${str.moodRate5}',
      MoodRate.mr6 => '6 - ${str.moodRate6}',
      MoodRate.mr7 => '7 - ${str.moodRate7}',
      MoodRate.mr8 => '8 - ${str.moodRate8}',
      MoodRate.mr9 => '9 - ${str.moodRate9}',
      MoodRate.mr10 => '10 - ${str.moodRate10}',
    };
  }
}
