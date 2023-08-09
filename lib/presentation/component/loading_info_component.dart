import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'gap/gap_components.dart';
import 'text/title_text_components.dart';

class LoadingInfo extends StatelessWidget {
  final String? loadingText;

  const LoadingInfo({
    super.key,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    final String loadingText =
        this.loadingText ?? '${Str.of(context).loading}...';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const Gap16(),
          TitleSmall(loadingText),
        ],
      ),
    );
  }
}
