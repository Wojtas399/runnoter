import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/activity_status_creator/activity_status_creator_bloc.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../service/dialog_service.dart';
import 'activity_status_creator_content.dart';

@RoutePage()
class ActivityStatusCreatorScreen extends StatelessWidget {
  final String? entityType;
  final String? entityId;

  const ActivityStatusCreatorScreen({
    super.key,
    @PathParam('entityType') this.entityType,
    @PathParam('entityId') this.entityId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ActivityStatusCreatorBloc(
        entityType: entityType != null
            ? ActivityStatusCreatorEntityType.values.byName(entityType!)
            : null,
        entityId: entityId,
      )..add(const ActivityStatusCreatorEventInitialize()),
      child: const _BlocListener(
        child: ActivityStatusCreatorContent(),
      ),
    );
  }
}

class _BlocListener extends StatelessWidget {
  final Widget child;

  const _BlocListener({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocWithStatusListener<ActivityStatusCreatorBloc,
        ActivityStatusCreatorState, ActivityStatusCreatorBlocInfo, dynamic>(
      onInfo: (ActivityStatusCreatorBlocInfo info) =>
          _manageInfo(context, info),
      child: child,
    );
  }

  void _manageInfo(BuildContext context, ActivityStatusCreatorBlocInfo info) {
    switch (info) {
      case ActivityStatusCreatorBlocInfo.activityStatusSaved:
        context.back();
        showSnackbarMessage(
            Str.of(context).activityStatusCreatorSavedStatusMessage);
        break;
    }
  }
}
