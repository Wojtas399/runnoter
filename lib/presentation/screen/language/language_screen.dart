import 'package:flutter/material.dart';

import '../../service/navigator_service.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Język',
        ),
        leading: IconButton(
          onPressed: () {
            navigateBack(context: context);
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Text('Wybór języka'),
        ),
      ),
    );
  }
}
