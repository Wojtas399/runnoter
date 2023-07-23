import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/blood_test_creator/blood_test_creator_bloc.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import 'blood_test_creator_content.dart';

@RoutePage()
class BloodTestCreatorScreen extends StatelessWidget {
  final String? bloodTestId;

  const BloodTestCreatorScreen({
    super.key,
    @PathParam('bloodTestId') this.bloodTestId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BloodTestCreatorBloc(bloodTestId: bloodTestId)
        ..add(const BloodTestCreatorEventInitialize()),
      child: const _BlocListener(
        child: BloodTestCreatorContent(),
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
    return BlocWithStatusListener<BloodTestCreatorBloc, BloodTestCreatorState,
        BloodTestCreatorBlocInfo, dynamic>(
      onInfo: (BloodTestCreatorBlocInfo info) {
        _manageInfo(context, info);
      },
      child: child,
    );
  }

  void _manageInfo(
    BuildContext context,
    BloodTestCreatorBlocInfo info,
  ) {
    final str = Str.of(context);
    if (info == BloodTestCreatorBlocInfo.bloodTestAdded) {
      navigateBack();
      showSnackbarMessage(str.bloodTestCreatorSuccessfullyAddedTest);
    } else if (info == BloodTestCreatorBlocInfo.bloodTestUpdated) {
      navigateBack();
      showSnackbarMessage(str.bloodTestCreatorSuccessfullyEditedTest);
    }
  }
}
