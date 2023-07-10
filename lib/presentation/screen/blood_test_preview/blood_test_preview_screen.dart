import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/blood_test_preview/blood_test_preview_bloc.dart';
import '../../../domain/entity/blood_parameter.dart';
import '../../../domain/repository/blood_test_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/blood_parameter_results_list_component.dart';
import '../../component/edit_delete_popup_menu_component.dart';
import '../../component/text/title_text_components.dart';
import '../../config/navigation/routes.dart';
import '../../formatter/date_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';

part 'blood_test_preview_app_bar.dart';
part 'blood_test_preview_content.dart';

class BloodTestPreviewScreen extends StatelessWidget {
  final String bloodTestId;

  const BloodTestPreviewScreen({
    super.key,
    required this.bloodTestId,
  });

  @override
  Widget build(BuildContext context) {
    return _BlocProvider(
      bloodTestId: bloodTestId,
      child: const _BlocListener(
        child: _Content(),
      ),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final String bloodTestId;
  final Widget child;

  const _BlocProvider({
    required this.bloodTestId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BloodTestPreviewBloc(
        authService: context.read<AuthService>(),
        bloodTestRepository: context.read<BloodTestRepository>(),
      )..add(
          BloodTestPreviewEventInitialize(
            bloodTestId: bloodTestId,
          ),
        ),
      child: child,
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
