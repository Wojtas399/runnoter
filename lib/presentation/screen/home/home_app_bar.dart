import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/bloc/home/home_bloc.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/nullable_text_component.dart';
import '../../config/navigation/router.dart';
import '../../extension/context_extensions.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color? backgroundColor;
  final VoidCallback onMenuPressed;
  final VoidCallback onAvatarPressed;

  const HomeAppBar({
    super.key,
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
                  if (context.isTabletSize) Image.asset('assets/logo.png'),
                  if (context.isDesktopSize)
                    _DesktopLeftPart(onMenuPressed: onMenuPressed),
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

class _DesktopLeftPart extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const _DesktopLeftPart({
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onMenuPressed,
          icon: const Icon(Icons.menu),
        ),
        const GapHorizontal24(),
        Image.asset('assets/logo.png'),
      ],
    );
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
