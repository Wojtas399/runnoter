import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/additional_model/run_status.dart';

extension RunStatusFormatter on RunStatus {
  IconData toIcon() => switch (this) {
        RunStatusPending() => Icons.schedule,
        RunStatusDone() => Icons.check_circle_outline,
        RunStatusAborted() => Icons.stop_circle_outlined,
        RunStatusUndone() => Icons.cancel_outlined,
      };

  String toLabel(BuildContext context) => switch (this) {
        RunStatusPending() => Str.of(context).runStatusPending,
        RunStatusDone() => Str.of(context).runStatusDone,
        RunStatusAborted() => Str.of(context).runStatusAborted,
        RunStatusUndone() => Str.of(context).runStatusUndone,
      };

  Color toColor(BuildContext context) => switch (this) {
        RunStatusPending() => switch (Theme.of(context).brightness) {
            Brightness.light => const Color(0xFF855400),
            Brightness.dark => const Color(0xFFFFB95C),
          },
        RunStatusDone() => switch (Theme.of(context).brightness) {
            Brightness.light => const Color(0xFF296C24),
            Brightness.dark => const Color(0xFF90d882),
          },
        RunStatusAborted() => switch (Theme.of(context).brightness) {
            Brightness.light => const Color(0xFF4A6267),
            Brightness.dark => const Color(0xFFB1CBD0),
          },
        RunStatusUndone() => Theme.of(context).colorScheme.error,
      };
}
