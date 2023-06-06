import 'package:flutter/material.dart';

import '../../component/big_button_component.dart';
import '../../config/navigation/routes.dart';
import '../../service/navigator_service.dart';

class CompetitionsScreen extends StatelessWidget {
  const CompetitionsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          BigButton(
            label: 'Nowe zawody',
            onPressed: () {
              navigateTo(
                context: context,
                route: const CompetitionCreatorRoute(),
              );
            },
          ),
        ],
      ),
    );
  }
}
