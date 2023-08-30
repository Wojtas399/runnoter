import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/required_data_completion/required_data_completion_bloc.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../service/navigator_service.dart';
import 'required_data_completion_content.dart';

class RequiredDataCompletionDialog extends StatelessWidget {
  const RequiredDataCompletionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RequiredDataCompletionBloc(),
      child: const _BlocListener(
        child: RequiredDataCompletionContent(),
      ),
    );
  }
}

class _BlocListener extends StatelessWidget {
  final Widget child;

  const _BlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocWithStatusListener<RequiredDataCompletionBloc,
        RequiredDataCompletionState, RequiredDataCompletionBlocInfo, dynamic>(
      onInfo: (RequiredDataCompletionBlocInfo info) =>
          _manageBlocInfo(context, info),
      child: child,
    );
  }

  void _manageBlocInfo(
    BuildContext context,
    RequiredDataCompletionBlocInfo info,
  ) {
    switch (info) {
      case RequiredDataCompletionBlocInfo.userDataAdded:
        popRoute(result: true);
        break;
    }
  }
}
