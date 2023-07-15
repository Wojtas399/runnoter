part of 'home_screen.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color? backgroundColor;
  final VoidCallback onMenuPressed;
  final VoidCallback onAvatarPressed;

  const _AppBar({
    this.backgroundColor,
    required this.onMenuPressed,
    required this.onAvatarPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: context.isMobileSize,
      title:
          context.isMobileSize ? NullableText(_getAppBarTitle(context)) : null,
      flexibleSpace: context.isMobileSize
          ? null
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 32, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (context.isDesktopSize)
                    Row(
                      children: [
                        IconButton(
                          onPressed: onMenuPressed,
                          icon: const Icon(Icons.menu),
                        ),
                        const SizedBox(width: 24),
                        Image.asset('assets/logo.png'),
                      ],
                    ),
                  _Avatar(onPressed: onAvatarPressed),
                ],
              ),
            ),
      actions: [
        if (context.isMobileSize)
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: _Avatar(onPressed: onAvatarPressed),
          ),
      ],
    );
  }

  String? _getAppBarTitle(BuildContext context) {
    final router = GetIt.I.get<AppRouter>();
    final homeRoute = router.root.innerRouterOf(HomeBaseRoute.name);
    return homeRoute?.innerRouterOf(HomeRoute.name)?.current.title(context);
  }
}

class _Avatar extends StatelessWidget {
  final VoidCallback onPressed;

  const _Avatar({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final String? loggedUserName = context.select(
      (HomeBloc bloc) => bloc.state.loggedUserName,
    );
    return IconButton(
      onPressed: onPressed,
      padding: const EdgeInsets.all(0),
      icon: CircleAvatar(
        radius: 18,
        child: Text(loggedUserName?[0] ?? '?'),
      ),
    );
  }
}
