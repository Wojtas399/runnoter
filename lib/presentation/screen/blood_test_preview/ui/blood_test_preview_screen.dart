import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/model/blood_reading.dart';
import '../../../../domain/repository/blood_reading_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../component/blood_reading_parameters_component.dart';
import '../../../component/text/title_text_components.dart';
import '../../../formatter/date_formatter.dart';
import '../bloc/blood_reading_preview_bloc.dart';

part 'blood_test_preview_content.dart';
part 'blood_test_preview_readings.dart';

class BloodTestPreviewScreen extends StatelessWidget {
  final String bloodReadingId;

  const BloodTestPreviewScreen({
    super.key,
    required this.bloodReadingId,
  });

  @override
  Widget build(BuildContext context) {
    return _BlocProvider(
      bloodReadingId: bloodReadingId,
      child: const _Content(),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final String bloodReadingId;
  final Widget child;

  const _BlocProvider({
    required this.bloodReadingId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BloodReadingPreviewBloc(
        authService: context.read<AuthService>(),
        bloodReadingRepository: context.read<BloodReadingRepository>(),
      )..add(
          BloodReadingPreviewEventInitialize(
            bloodReadingId: bloodReadingId,
          ),
        ),
      child: child,
    );
  }
}
