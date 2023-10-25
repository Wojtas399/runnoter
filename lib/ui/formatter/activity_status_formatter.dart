import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/model/activity.dart';

extension ActivityStatusFormatter on ActivityStatus {
  IconData toIcon() => switch (this) {
        ActivityStatusPending() => Icons.schedule,
        ActivityStatusDone() => Icons.check_circle_outline,
        ActivityStatusAborted() => Icons.stop_circle_outlined,
        ActivityStatusUndone() => Icons.cancel_outlined,
      };

  String toLabel(BuildContext context) {
    final str = Str.of(context);
    return switch (this) {
      ActivityStatusPending() => str.activityStatusPending,
      ActivityStatusDone() => str.activityStatusDone,
      ActivityStatusAborted() => str.activityStatusAborted,
      ActivityStatusUndone() => str.activityStatusUndone,
    };
  }

  Color toColor(BuildContext context) => switch (this) {
        ActivityStatusPending() => switch (Theme.of(context).brightness) {
            Brightness.light => const Color(0xFF855400),
            Brightness.dark => const Color(0xFFFFB95C),
          },
        ActivityStatusDone() => switch (Theme.of(context).brightness) {
            Brightness.light => const Color(0xFF296C24),
            Brightness.dark => const Color(0xFF90d882),
          },
        ActivityStatusAborted() => switch (Theme.of(context).brightness) {
            Brightness.light => const Color(0xFF4A6267),
            Brightness.dark => const Color(0xFFB1CBD0),
          },
        ActivityStatusUndone() => Theme.of(context).colorScheme.error,
      };
}
