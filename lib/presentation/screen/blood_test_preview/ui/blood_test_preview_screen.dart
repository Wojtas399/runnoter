import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/model/blood_parameter.dart';
import '../../../../domain/repository/blood_test_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../component/blood_parameter_results_list_component.dart';
import '../../../component/text/title_text_components.dart';
import '../../../formatter/date_formatter.dart';
import '../bloc/blood_test_preview_bloc.dart';

part 'blood_test_preview_app_bar.dart';
part 'blood_test_preview_content.dart';
part 'blood_test_preview_readings.dart';

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
      child: const _Content(),
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
