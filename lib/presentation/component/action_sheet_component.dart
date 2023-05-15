import 'package:flutter/material.dart';

import 'text/body_text_components.dart';

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

  const ActionSheetComponent({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
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
