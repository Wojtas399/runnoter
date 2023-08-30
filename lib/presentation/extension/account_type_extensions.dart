import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/entity/user.dart';

extension AccountTypeExtensions on AccountType {
  String toUIFormat(BuildContext context) => switch (this) {
        AccountType.runner => Str.of(context).runner,
        AccountType.coach => Str.of(context).coach,
      };
}
