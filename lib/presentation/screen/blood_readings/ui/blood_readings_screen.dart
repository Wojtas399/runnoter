import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../component/big_button_component.dart';
import '../../../config/navigation/routes.dart';
import '../../../service/navigator_service.dart';

class BloodReadingsScreen extends StatelessWidget {
  const BloodReadingsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          BigButton(
            label: Str.of(context).bloodAddBloodTest,
            onPressed: () {
              _onPressed(context);
            },
          ),
        ],
      ),
    );
  }

  void _onPressed(BuildContext context) {
    navigateTo(
      context: context,
      route: const BloodTestCreatorRoute(),
    );
  }
}
