import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../common/date_service.dart';
import '../../../../domain/repository/morning_measurement_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../component/big_button_component.dart';
import '../../../component/full_screen_dialog_component.dart';
import '../../../component/text_field_component.dart';
import '../../../formatter/decimal_text_input_formatter.dart';
import '../../../service/dialog_service.dart';
import '../../../service/utils.dart';
import '../bloc/health_bloc.dart';

part 'health_content.dart';
part 'health_morning_measurement_dialog.dart';
part 'health_today_morning_measurement.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _BlocProvider(
      child: _Content(),
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
      create: (BuildContext context) => HealthBloc(
        dateService: DateService(),
        authService: context.read<AuthService>(),
        morningMeasurementRepository:
            context.read<MorningMeasurementRepository>(),
      ),
      child: child,
    );
  }
}
