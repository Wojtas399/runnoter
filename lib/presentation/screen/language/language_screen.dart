import 'package:flutter/material.dart';

import '../../../domain/model/settings.dart';
import '../../service/navigator_service.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _Content();
  }
}

class _Content extends StatelessWidget {
  const _Content();

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _Header(),
            SizedBox(height: 16),
            _OptionsToSelect(),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Text(
        'Wybierz język aplikacji',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class _OptionsToSelect extends StatelessWidget {
  const _OptionsToSelect();

  @override
  Widget build(BuildContext context) {
    const Language selectedLanguage = Language.polish;

    return Column(
      children: [
        RadioListTile<Language>(
          title: Text(
            'Polski',
          ),
          value: Language.polish,
          groupValue: selectedLanguage,
          onChanged: (Language? language) {
            //TODO
          },
        ),
        RadioListTile<Language>(
          title: Text(
            'Angielski',
          ),
          value: Language.english,
          groupValue: selectedLanguage,
          onChanged: (Language? language) {
            //TODO
          },
        ),
      ],
    );
  }
}
