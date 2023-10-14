import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/entity/user.dart';

extension GenderFormatter on Gender {
  String toUIFormat(BuildContext context) => switch (this) {
        Gender.male => Str.of(context).male,
        Gender.female => Str.of(context).female,
      };

  IconData toIconData() => switch (this) {
        Gender.male => Icons.male,
        Gender.female => Icons.female,
      };
}
