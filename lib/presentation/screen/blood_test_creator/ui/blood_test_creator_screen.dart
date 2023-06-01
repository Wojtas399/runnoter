import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/model/blood_parameter.dart';
import '../../../../domain/repository/blood_test_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../component/bloc_with_status_listener_component.dart';
import '../../../component/blood_parameter_results_list_component.dart';
import '../../../component/text/title_text_components.dart';
import '../../../formatter/date_formatter.dart';
import '../../../service/navigator_service.dart';
import '../../../service/utils.dart';
import '../bloc/blood_test_creator_bloc.dart';

part 'blood_test_creator_content.dart';
part 'blood_test_creator_date.dart';
part 'blood_test_creator_parameters.dart';

class BloodTestCreatorScreen extends StatelessWidget {
  const BloodTestCreatorScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _BlocProvider(
      child: _BlocListener(
        child: _Content(),
      ),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final Widget child;

  const _BlocProvider({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BloodTestCreatorBloc(
        authService: context.read<AuthService>(),
        bloodTestRepository: context.read<BloodTestRepository>(),
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
    switch (info) {
      case BloodTestCreatorBlocInfo.bloodTestAdded:
        navigateBack(context: context);
        break;
    }
  }
}
