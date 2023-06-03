import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/blood_test_creator/blood_test_creator_bloc.dart';
import '../../../domain/model/blood_parameter.dart';
import '../../../domain/repository/blood_test_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/blood_parameter_results_list_component.dart';
import '../../component/text/title_text_components.dart';
import '../../formatter/date_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import '../../service/utils.dart';

part 'blood_test_creator_app_bar.dart';
part 'blood_test_creator_content.dart';
part 'blood_test_creator_date.dart';
part 'blood_test_creator_parameters.dart';

class BloodTestCreatorScreen extends StatelessWidget {
  final String? bloodTestId;

  const BloodTestCreatorScreen({
    super.key,
    this.bloodTestId,
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
  final String? bloodTestId;
  final Widget child;

  const _BlocProvider({
    this.bloodTestId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BloodTestCreatorBloc(
        authService: context.read<AuthService>(),
        bloodTestRepository: context.read<BloodTestRepository>(),
      )..add(
          BloodTestCreatorEventInitialize(bloodTestId: bloodTestId),
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
    if (info == BloodTestCreatorBlocInfo.bloodTestAdded) {
      navigateBack(context: context);
      showSnackbarMessage(
        context: context,
        message: Str.of(context).bloodTestCreatorSuccessfullyAddedTest,
      );
    } else if (info == BloodTestCreatorBlocInfo.bloodTestUpdated) {
      navigateBack(context: context);
      showSnackbarMessage(
        context: context,
        message: Str.of(context).bloodTestCreatorSuccessfullyEditedTest,
      );
    }
  }
}
