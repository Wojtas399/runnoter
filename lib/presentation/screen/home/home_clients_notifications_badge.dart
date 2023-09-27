import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/cubit/notifications/notifications_cubit.dart';

class HomeClientsNotificationsBadge extends StatelessWidget {
  final bool showEmptyBadge;
  final Widget? child;

  const HomeClientsNotificationsBadge({
    super.key,
    this.showEmptyBadge = false,
    this.child,
  });

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
      label: showEmptyBadge ? null : Text('$numberOfNotifications'),
      child: child,
    );
  }
}
