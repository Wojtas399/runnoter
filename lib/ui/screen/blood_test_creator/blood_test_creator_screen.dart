import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../component/cubit_with_status_listener_component.dart';
import '../../component/page_not_found_component.dart';
import '../../cubit/blood_test_creator/blood_test_creator_cubit.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import 'blood_test_creator_content.dart';

@RoutePage()
class BloodTestCreatorScreen extends StatelessWidget {
  final String? userId;
  final String? bloodTestId;

  const BloodTestCreatorScreen({
    super.key,
    @PathParam('userId') this.userId,
    @PathParam('bloodTestId') this.bloodTestId,
  });

  @override
  Widget build(BuildContext context) {
    return userId != null
        ? BlocProvider(
            create: (_) => BloodTestCreatorCubit(
              userId: userId!,
              bloodTestId: bloodTestId,
            )..initialize(),
            child: const _CubitListener(
              child: BloodTestCreatorContent(),
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
    return CubitWithStatusListener<BloodTestCreatorCubit, BloodTestCreatorState,
        BloodTestCreatorCubitInfo, BloodTestCreatorCubitError>(
      onInfo: (BloodTestCreatorCubitInfo info) => _manageInfo(context, info),
      onError: (BloodTestCreatorCubitError error) =>
          _manageError(context, error),
      child: child,
    );
  }

  void _manageInfo(BuildContext context, BloodTestCreatorCubitInfo info) {
    final str = Str.of(context);
    if (info == BloodTestCreatorCubitInfo.bloodTestAdded) {
      navigateBack();
      showSnackbarMessage(str.bloodTestCreatorSuccessfullyAddedTest);
    } else if (info == BloodTestCreatorCubitInfo.bloodTestUpdated) {
      navigateBack();
      showSnackbarMessage(str.bloodTestCreatorSuccessfullyEditedTest);
    }
  }

  Future<void> _manageError(
    BuildContext context,
    BloodTestCreatorCubitError error,
  ) async {
    final str = Str.of(context);
    switch (error) {
      case BloodTestCreatorCubitError.bloodTestNoLongerExists:
        await showMessageDialog(
          title: str.bloodTestCreatorBloodTestNoLongerExistsDialogTitle,
          message: str.bloodTestCreatorBloodTestNoLongerExistsDialogMessage,
        );
        if (context.mounted) {
          context.router.removeLast();
          context.router.removeLast();
        }
    }
  }
}
