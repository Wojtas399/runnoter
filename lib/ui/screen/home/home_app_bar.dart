import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../component/date_range_header_component.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/nullable_text_component.dart';
import '../../config/navigation/router.dart';
import '../../cubit/calendar/calendar_cubit.dart';
import '../../cubit/date_range_manager_cubit.dart';
import '../../cubit/home/home_cubit.dart';
import '../../cubit/notifications/notifications_cubit.dart';
import '../../extension/context_extensions.dart';

class HomeMobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final RouteData currentRoute;
  final VoidCallback onMenuPressed;
  final VoidCallback onAvatarPressed;

  const HomeMobileAppBar({
    super.key,
    required this.currentRoute,
    required this.onMenuPressed,
    required this.onAvatarPressed,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        currentRoute.name == CalendarRoute.name
            ? kIsWeb
                ? 160
                : 180
            : kToolbarHeight,
      );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: true,
      title: NullableText(_getAppBarTitle(context)),
      leading: IconButton(
        icon: const _DrawerBadge(
          child: Icon(Icons.menu),
        ),
        onPressed: Scaffold.of(context).openDrawer,
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: _Avatar(onPressed: onAvatarPressed),
        ),
      ],
      bottom: currentRoute.name == CalendarRoute.name
          ? _MobileDateRangeHeader()
          : null,
    );
  }

  String? _getAppBarTitle(BuildContext context) {
    final router = GetIt.I.get<AppRouter>();
    final homeRoute = router.root.innerRouterOf(HomeBaseRoute.name);
    return homeRoute?.innerRouterOf(HomeRoute.name)?.current.title(context);
  }
}

class HomeDesktopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color? backgroundColor;
  final VoidCallback onMenuPressed;
  final VoidCallback onAvatarPressed;

  const HomeDesktopAppBar({
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
      centerTitle: true,
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      flexibleSpace: Padding(
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
    );
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

  const _Avatar({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final String? loggedUserName = context.select(
      (HomeCubit cubit) => cubit.state.loggedUserName,
    );

    return IconButton(
      onPressed: onPressed,
      padding: const EdgeInsets.all(0),
      icon: _ProfileBadge(
        child: CircleAvatar(
          radius: 18,
          child: Text(loggedUserName?[0] ?? '?'),
        ),
      ),
    );
  }
}

class _MobileDateRangeHeader extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    final DateRangeType dateRangeType = context.select(
      (CalendarCubit cubit) => cubit.state.dateRangeType,
    );
    final DateRange? dateRange = context.select(
      (CalendarCubit cubit) => cubit.state.dateRange,
    );

    return dateRange != null
        ? Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: DateRangeHeader(
              selectedDateRangeType: dateRangeType,
              dateRange: dateRange,
              onWeekSelected: () => context
                  .read<CalendarCubit>()
                  .changeDateRangeType(DateRangeType.week),
              onMonthSelected: () => context
                  .read<CalendarCubit>()
                  .changeDateRangeType(DateRangeType.month),
              onPreviousRangePressed:
                  context.read<CalendarCubit>().previousDateRange,
              onNextRangePressed: context.read<CalendarCubit>().nextDateRange,
            ),
          )
        : const SizedBox();
  }
}

class _DrawerBadge extends StatelessWidget {
  final Widget child;

  const _DrawerBadge({required this.child});

  @override
  Widget build(BuildContext context) {
    final int numberOfUnreadClientMessages = context.select(
      (NotificationsCubit cubit) =>
          cubit.state.idsOfClientsWithAwaitingMessages.length,
    );
    final int numberOfCoachingReqsFromClients = context.select(
      (NotificationsCubit cubit) =>
          cubit.state.numberOfCoachingRequestsFromClients,
    );
    final int numberOfNotifications =
        numberOfUnreadClientMessages + numberOfCoachingReqsFromClients;

    return Badge(
      isLabelVisible: numberOfNotifications > 0,
      child: child,
    );
  }
}

class _ProfileBadge extends StatelessWidget {
  final Widget child;

  const _ProfileBadge({required this.child});

  @override
  Widget build(BuildContext context) {
    final bool? areThereUnreadMessagesFromCoach = context.select(
      (NotificationsCubit cubit) => cubit.state.areThereUnreadMessagesFromCoach,
    );
    final bool areThereCoachingReqsFromCoaches = context.select(
      (NotificationsCubit cubit) =>
          cubit.state.numberOfCoachingRequestsFromCoaches > 0,
    );

    return Badge(
      isLabelVisible: areThereUnreadMessagesFromCoach == true ||
          areThereCoachingReqsFromCoaches,
      child: child,
    );
  }
}
