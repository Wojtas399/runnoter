import 'package:flutter/material.dart';

import '../../component/big_button_component.dart';

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
              //TODO
            },
          ),
        ],
      ),
    );
  }
}
