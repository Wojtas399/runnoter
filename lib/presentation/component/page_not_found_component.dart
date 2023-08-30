import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'empty_content_info_component.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EmptyContentInfo(
        icon: Icons.warning,
        title: Str.of(context).pageNotFoundTitle,
        subtitle: Str.of(context).pageNotFoundMessage,
      ),
    );
  }
}
