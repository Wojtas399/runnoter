part of 'sign_in_screen.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

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
