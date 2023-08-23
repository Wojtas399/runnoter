import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/blood_test_preview/blood_test_preview_bloc.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/page_not_found_component.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import 'blood_test_preview_content.dart';

@RoutePage()
class BloodTestPreviewScreen extends StatelessWidget {
  final String? userId;
  final String? bloodTestId;

  const BloodTestPreviewScreen({
    super.key,
    @PathParam('userId') this.userId,
    @PathParam('bloodTestId') this.bloodTestId,
  });

  @override
  Widget build(BuildContext context) {
    return userId != null && bloodTestId != null
        ? BlocProvider(
            create: (_) => BloodTestPreviewBloc(
              userId: userId!,
              bloodTestId: bloodTestId!,
            )..add(const BloodTestPreviewEventInitialize()),
            child: const _BlocListener(
              child: BloodTestPreviewContent(),
            ),
          )
        : const PageNotFound();
  }
}

class _BlocListener extends StatelessWidget {
  final Widget child;

  const _BlocListener({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocWithStatusListener<BloodTestPreviewBloc, BloodTestPreviewState,
        BloodTestPreviewBlocInfo, dynamic>(
      onInfo: (BloodTestPreviewBlocInfo info) {
        _manageInfo(context, info);
      },
      child: child,
    );
  }

  void _manageInfo(
    BuildContext context,
    BloodTestPreviewBlocInfo info,
  ) {
    switch (info) {
      case BloodTestPreviewBlocInfo.bloodTestDeleted:
        navigateBack();
        showSnackbarMessage(Str.of(context).bloodTestPreviewDeletedTestMessage);
        break;
    }
  }
}
