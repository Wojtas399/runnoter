import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/entity/run_status.dart';

extension RunStatusFormatter on RunStatus {
  IconData toIcon() {
    if (this is RunStatusPending) {
      return Icons.schedule;
    } else if (this is RunStatusDone) {
      return Icons.check_circle_outline;
    } else if (this is RunStatusAborted) {
      return Icons.stop_circle_outlined;
    } else if (this is RunStatusUndone) {
      return Icons.cancel_outlined;
    } else {
      throw '[RunStatusFormatter - toIcon()]: Unknown status type';
    }
  }

  String toLabel(BuildContext context) {
    final str = Str.of(context);
    if (this is RunStatusPending) {
      return str.runStatusPending;
    } else if (this is RunStatusDone) {
      return str.runStatusDone;
    } else if (this is RunStatusAborted) {
      return str.runStatusAborted;
    } else if (this is RunStatusUndone) {
      return str.runStatusUndone;
    } else {
      throw '[RunStatusFormatter - toLabel()]: Unknown status type';
    }
  }

  Color toColor() {
    if (this is RunStatusPending) {
      return Colors.deepOrangeAccent;
    } else if (this is RunStatusDone) {
      return Colors.green;
    } else if (this is RunStatusAborted) {
      return Colors.grey;
    } else if (this is RunStatusUndone) {
      return Colors.red;
    } else {
      throw '[RunStatusFormatter - toColor()]: Unknown status type';
    }
  }
}
