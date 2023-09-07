import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/cubit/required_data_completion/required_data_completion_cubit.dart';
import '../../component/cubit_with_status_listener_component.dart';
import '../../service/navigator_service.dart';
import 'required_data_completion_content.dart';

class RequiredDataCompletionDialog extends StatelessWidget {
  const RequiredDataCompletionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RequiredDataCompletionCubit(),
      child: const _CubitListener(
        child: RequiredDataCompletionContent(),
      ),
    );
  }
}

class _CubitListener extends StatelessWidget {
  final Widget child;

  const _CubitListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return CubitWithStatusListener<RequiredDataCompletionCubit,
        RequiredDataCompletionState, RequiredDataCompletionCubitInfo, dynamic>(
      onInfo: (RequiredDataCompletionCubitInfo info) =>
          _manageBlocInfo(context, info),
      child: child,
    );
  }

  void _manageBlocInfo(
    BuildContext context,
    RequiredDataCompletionCubitInfo info,
  ) {
    switch (info) {
      case RequiredDataCompletionCubitInfo.userDataAdded:
        popRoute(result: true);
        break;
    }
  }
}
