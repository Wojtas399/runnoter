import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../config/navigation/router.dart';
import '../../service/navigator_service.dart';

class ClientMobileMessageFAB extends StatelessWidget {
  const ClientMobileMessageFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SmallFAB();
  }
}

class ClientDrawerMessageFAB extends StatelessWidget {
  const ClientDrawerMessageFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton.extended(
          onPressed: () => _onPressed(context),
          label: Text(Str.of(context).message),
          icon: const Icon(Icons.message),
        ),
      ],
    );
  }
}

class ClientRailMessageFAB extends StatelessWidget {
  const ClientRailMessageFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: _SmallFAB(),
    );
  }
}

class _SmallFAB extends StatelessWidget {
  const _SmallFAB();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      onPressed: () => _onPressed(context),
      child: const Icon(Icons.message),
    );
  }
}

void _onPressed(BuildContext context) {
  navigateTo(
    ChatRoute(chatId: 'c1'), //TODO: Read chat it from client cubit
  );
}
