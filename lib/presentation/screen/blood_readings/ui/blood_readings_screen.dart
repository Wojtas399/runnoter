import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/model/blood_reading.dart';
import '../../../../domain/repository/blood_reading_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../component/big_button_component.dart';
import '../../../component/empty_content_info_component.dart';
import '../../../component/text/title_text_components.dart';
import '../../../config/navigation/routes.dart';
import '../../../formatter/date_formatter.dart';
import '../../../service/navigator_service.dart';
import '../blood_readings_cubit.dart';

part 'blood_readings_content.dart';
part 'blood_readings_list.dart';

class BloodReadingsScreen extends StatelessWidget {
  const BloodReadingsScreen({
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
      create: (_) => BloodReadingsCubit(
        authService: context.read<AuthService>(),
        bloodReadingRepository: context.read<BloodReadingRepository>(),
      )..initialize(),
      child: child,
    );
  }
}
