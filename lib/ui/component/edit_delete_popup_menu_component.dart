import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'gap/gap_horizontal_components.dart';

enum _Action { edit, delete }

class EditDeleteActions extends StatelessWidget {
  final bool displayAsPopupMenu;
  final VoidCallback? onEditSelected;
  final VoidCallback? onDeleteSelected;

  const EditDeleteActions({
    super.key,
    this.displayAsPopupMenu = false,
    this.onEditSelected,
    this.onDeleteSelected,
  });

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    final theme = Theme.of(context);
    const IconData editIcon = Icons.edit_outlined;
    const IconData deleteIcon = Icons.delete_outline;

    if (displayAsPopupMenu == true) {
      return PopupMenuButton<_Action>(
        icon: const Icon(Icons.more_vert),
        onSelected: (_Action action) => _manageActions(context, action),
        itemBuilder: (BuildContext context) => [
          PopupMenuItem<_Action>(
            value: _Action.edit,
            child: Row(
              children: [
                const Icon(editIcon),
                const GapHorizontal8(),
                Text(str.edit),
              ],
            ),
          ),
          PopupMenuItem<_Action>(
            value: _Action.delete,
            child: Row(
              children: [
                const Icon(deleteIcon),
                const GapHorizontal8(),
                Text(str.delete),
              ],
            ),
          ),
        ],
      );
    }
    return Row(
      children: [
        Tooltip(
          message: str.edit,
          child: IconButton(
            onPressed: _emitEditEvent,
            icon: Icon(editIcon, color: theme.colorScheme.primary),
          ),
        ),
        Tooltip(
          message: str.delete,
          child: IconButton(
            onPressed: _emitDeleteEvent,
            icon: Icon(deleteIcon, color: theme.colorScheme.error),
          ),
        ),
      ],
    );
  }

  void _manageActions(BuildContext context, _Action action) {
    switch (action) {
      case _Action.edit:
        _emitEditEvent();
        break;
      case _Action.delete:
        _emitDeleteEvent();
        break;
    }
  }

  void _emitEditEvent() {
    if (onEditSelected != null) onEditSelected!();
  }

  void _emitDeleteEvent() {
    if (onDeleteSelected != null) onDeleteSelected!();
  }
}
