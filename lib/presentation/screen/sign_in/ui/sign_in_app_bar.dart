import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../service/theme_service.dart';

class SignInAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SignInAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeMode themeMode = context.select(
      (ThemeService service) => service.state,
    );

    return AppBar(
      actions: [
        Icon(
          themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
          size: 24,
        ),
        const SizedBox(width: 8),
        Switch(
          value: themeMode == ThemeMode.dark,
          onChanged: (bool isSwitched) {
            _onSwitched(context, isSwitched);
          },
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _onSwitched(BuildContext context, bool isSwitched) {
    final ThemeService service = context.read<ThemeService>();
    if (isSwitched) {
      service.changeTheme(ThemeMode.dark);
    } else {
      service.changeTheme(ThemeMode.light);
    }
  }
}
