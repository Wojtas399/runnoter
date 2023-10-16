import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/entity/user.dart';

extension DistanceUnitFormatter on DistanceUnit {
  String toUIFullFormat(BuildContext context) => switch (this) {
        DistanceUnit.kilometers => Str.of(context).distanceUnitKilometers,
        DistanceUnit.miles => Str.of(context).distanceUnitMiles,
      };

  String toUIShortFormat() => switch (this) {
        DistanceUnit.kilometers => 'km',
        DistanceUnit.miles => 'mil',
      };
}
