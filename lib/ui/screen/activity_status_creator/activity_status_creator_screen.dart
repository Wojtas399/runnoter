import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../component/cubit_with_status_listener_component.dart';
import '../../component/page_not_found_component.dart';
import '../../cubit/activity_status_creator/activity_status_creator_cubit.dart';
import '../../service/dialog_service.dart';
import 'activity_status_creator_content.dart';

@RoutePage()
class ActivityStatusCreatorScreen extends StatelessWidget {
  final String? userId;
  final String? activityType;
  final String? activityId;

  const ActivityStatusCreatorScreen({
    super.key,
    @PathParam('userId') this.userId,
    @PathParam('activityType') this.activityType,
    @PathParam('activityId') this.activityId,
  });

  @override
  Widget build(BuildContext context) {
    return userId != null && activityType != null && activityId != null
        ? BlocProvider(
            create: (_) => ActivityStatusCreatorCubit(
              userId: userId!,
              activityType: ActivityType.values.byName(activityType!),
              activityId: activityId!,
            )..initialize(),
            child: const _CubitListener(
              child: ActivityStatusCreatorContent(),
            ),
          )
        : const PageNotFound();
  }
}

class _CubitListener extends StatelessWidget {
  final Widget child;

  const _CubitListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return CubitWithStatusListener<ActivityStatusCreatorCubit,
        ActivityStatusCreatorState, ActivityStatusCreatorCubitInfo, dynamic>(
      onInfo: (ActivityStatusCreatorCubitInfo info) =>
          _manageInfo(context, info),
      child: child,
    );
  }

  void _manageInfo(BuildContext context, ActivityStatusCreatorCubitInfo info) {
    switch (info) {
      case ActivityStatusCreatorCubitInfo.activityStatusSaved:
        context.back();
        showSnackbarMessage(
            Str.of(context).activityStatusCreatorSavedStatusMessage);
        break;
    }
  }
}
