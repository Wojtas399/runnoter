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
    final int numberOfCoachingRequestsReceivedFromClients = context.select(
      (NotificationsCubit cubit) =>
          cubit.state.numberOfCoachingRequestsReceivedFromClients,
    );
    final int numberOfNotifications = numberOfUnreadClientMessages +
        numberOfCoachingRequestsReceivedFromClients;

    return Badge(
      isLabelVisible: numberOfNotifications > 0,
      label: showEmptyBadge ? null : Text('$numberOfNotifications'),
      child: child,
    );
  }
}
