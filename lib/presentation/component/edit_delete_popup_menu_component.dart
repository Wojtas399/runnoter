import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum _Action { edit, delete }

class EditDeletePopupMenu extends StatelessWidget {
  final VoidCallback? onEditSelected;
  final VoidCallback? onDeleteSelected;

  const EditDeletePopupMenu({
    super.key,
    this.onEditSelected,
    this.onDeleteSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_Action>(
      icon: const Icon(Icons.more_vert),
      onSelected: (_Action action) {
        _manageActions(context, action);
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<_Action>(
          value: _Action.edit,
          child: Row(
            children: [
              const Icon(Icons.edit_outlined),
              const SizedBox(width: 8),
              Text(Str.of(context).edit)
            ],
          ),
        ),
        PopupMenuItem<_Action>(
          value: _Action.delete,
          child: Row(
            children: [
              const Icon(Icons.delete_outline),
              const SizedBox(width: 8),
              Text(Str.of(context).delete),
            ],
          ),
        ),
      ],
    );
  }

  void _manageActions(BuildContext context, _Action action) {
    switch (action) {
      case _Action.edit:
        if (onEditSelected != null) onEditSelected!();
        break;
      case _Action.delete:
        if (onDeleteSelected != null) onDeleteSelected!();
        break;
    }
  }
}
