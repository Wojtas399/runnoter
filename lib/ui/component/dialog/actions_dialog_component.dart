import 'package:auto_route/auto_route.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActionsDialog<T> extends StatelessWidget {
  final List<ActionsDialogItem<T>> actions;

  const ActionsDialog({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...actions.map(
            (action) => ListTile(
              title: Text(action.label),
              leading: action.icon,
              onTap: () => context.popRoute(action.value),
            ),
          ),
          ListTile(
            title: Text(Str.of(context).cancel),
            leading: const Icon(Icons.close),
            onTap: () => context.popRoute(null),
          ),
        ],
      ),
    );
  }
}

class ActionsDialogItem<T> extends Equatable {
  final Icon icon;
  final String label;
  final T value;

  const ActionsDialogItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  List<Object?> get props => [icon, label, value];
}
