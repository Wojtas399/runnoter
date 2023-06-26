import 'package:flutter/material.dart';

import 'text/body_text_components.dart';
import 'text/title_text_components.dart';

class ActionSheetItem<T> {
  final T id;
  final String label;
  final IconData iconData;

  const ActionSheetItem({
    required this.id,
    required this.label,
    required this.iconData,
  });
}

class ActionSheetComponent extends StatelessWidget {
  final List<ActionSheetItem> actions;
  final String? title;

  const ActionSheetComponent({
    super.key,
    required this.actions,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) _Title(title: title!),
          ...actions.map(
            (ActionSheetItem action) => _createMaterialAction(
              action: action,
              context: context,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createMaterialAction({
    required ActionSheetItem action,
    required BuildContext context,
  }) {
    return ListTile(
      title: BodyLarge(action.label),
      leading: Icon(action.iconData),
      onTap: () {
        Navigator.pop(context, action.id);
      },
    );
  }
}

class _Title extends StatelessWidget {
  final String title;

  const _Title({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: TitleMedium(title),
    );
  }
}
