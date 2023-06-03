import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/entity/blood_test.dart';
import '../../../../domain/repository/blood_test_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../component/empty_content_info_component.dart';
import '../../../component/text/title_text_components.dart';
import '../../../config/navigation/routes.dart';
import '../../../formatter/date_formatter.dart';
import '../../../service/navigator_service.dart';
import '../blood_tests_cubit.dart';

part 'blood_tests_content.dart';
part 'blood_tests_list.dart';

class BloodTestsScreen extends StatelessWidget {
  const BloodTestsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _CubitProvider(
      child: _Content(),
    );
  }
}

class _CubitProvider extends StatelessWidget {
  final Widget child;

  const _CubitProvider({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BloodTestsCubit(
        authService: context.read<AuthService>(),
        bloodTestRepository: context.read<BloodTestRepository>(),
      )..initialize(),
      child: child,
    );
  }
}
