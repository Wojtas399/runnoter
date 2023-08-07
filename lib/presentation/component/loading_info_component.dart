import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'gap/gap_components.dart';
import 'text/title_text_components.dart';

class LoadingInfo extends StatelessWidget {
  const LoadingInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const Gap16(),
          TitleSmall(
            '${Str.of(context).loading}...',
          ),
        ],
      ),
    );
  }
}
