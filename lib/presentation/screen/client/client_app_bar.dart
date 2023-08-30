import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/calendar/calendar_bloc.dart';
import '../../../domain/bloc/client/client_bloc.dart';
import '../../../domain/cubit/date_range_manager_cubit.dart';
import '../../component/date_range_header_component.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/text/title_text_components.dart';
import '../../config/navigation/router.dart';
import '../../extension/context_extensions.dart';
import '../../service/navigator_service.dart';
import 'client_details.dart';

class ClientMobileAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final RouteData currentPage;

  const ClientMobileAppBar({super.key, required this.currentPage});

  @override
  Size get preferredSize => Size.fromHeight(
        currentPage.name == ClientCalendarRoute.name
            ? kIsWeb
                ? 160
                : 180
            : kToolbarHeight,
      );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: Theme.of(context).colorScheme.primary,
      centerTitle: true,
      title: const _AppBarTitle(),
      actions: const [ClientDetailsIcon(), GapHorizontal8()],
      bottom: currentPage.name == ClientCalendarRoute.name
          ? _MobileDateRangeHeader()
          : null,
    );
  }
}

class ClientDesktopAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Color? backgroundColor;

  const ClientDesktopAppBar({super.key, this.backgroundColor});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      foregroundColor: Theme.of(context).colorScheme.primary,
      centerTitle: true,
      leading: BackButton(
        onPressed: () => _onBackButtonPressed(context),
      ),
      title: const _AppBarTitle(),
      actions: const [ClientDetailsIcon(), GapHorizontal16()],
    );
  }

  Future<void> _onBackButtonPressed(BuildContext context) async {
    final bool isPopped = await Navigator.of(context).maybePop();
    if (!isPopped) {
      navigateTo(const HomeRoute());
    }
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    final String? fullName = context.select(
      (ClientBloc bloc) => bloc.state.name == null || bloc.state.surname == null
          ? null
          : '${bloc.state.name} ${bloc.state.surname}',
    );

    return fullName == null
        ? const CircularProgressIndicator()
        : TitleLarge(
            fullName,
            textAlign: context.isMobileSize ? TextAlign.center : null,
            overflow: context.isMobileSize ? TextOverflow.ellipsis : null,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
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
      (CalendarBloc bloc) => bloc.state.dateRangeType,
    );
    final DateRange? dateRange = context.select(
      (CalendarBloc bloc) => bloc.state.dateRange,
    );

    return dateRange != null
        ? Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: DateRangeHeader(
              selectedDateRangeType: dateRangeType,
              dateRange: dateRange,
              onWeekSelected: () =>
                  _onDateRangeTypeChanged(context, DateRangeType.week),
              onMonthSelected: () =>
                  _onDateRangeTypeChanged(context, DateRangeType.month),
              onPreviousRangePressed: () => _onPreviousDateRange(context),
              onNextRangePressed: () => _onNextDateRange(context),
            ),
          )
        : const SizedBox();
  }

  void _onDateRangeTypeChanged(
    BuildContext context,
    DateRangeType dateRangeType,
  ) {
    context.read<CalendarBloc>().add(
          CalendarEventChangeDateRangeType(dateRangeType: dateRangeType),
        );
  }

  void _onPreviousDateRange(BuildContext context) {
    context.read<CalendarBloc>().add(
          const CalendarEventPreviousDateRange(),
        );
  }

  void _onNextDateRange(BuildContext context) {
    context.read<CalendarBloc>().add(
          const CalendarEventNextDateRange(),
        );
  }
}
