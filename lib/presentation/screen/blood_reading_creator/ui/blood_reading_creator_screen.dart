import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../../../domain/model/blood_parameter.dart';
import '../../../../domain/repository/blood_reading_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../component/text/label_text_components.dart';
import '../../../component/text/title_text_components.dart';
import '../../../component/text_field_component.dart';
import '../../../formatter/blood_test_parameter_formatter.dart';
import '../../../formatter/blood_test_parameter_norm_formatter.dart';
import '../../../formatter/blood_test_parameter_unit_formatter.dart';
import '../../../formatter/date_formatter.dart';
import '../../../formatter/decimal_text_input_formatter.dart';
import '../../../service/utils.dart';
import '../bloc/blood_reading_creator_bloc.dart';

part 'blood_reading_creator_content.dart';
part 'blood_reading_creator_date.dart';
part 'blood_reading_creator_parameters.dart';

class BloodReadingCreatorScreen extends StatelessWidget {
  const BloodReadingCreatorScreen({
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
      create: (BuildContext context) => BloodReadingCreatorBloc(
        authService: context.read<AuthService>(),
        bloodReadingRepository: context.read<BloodReadingRepository>(),
      ),
      child: child,
    );
  }
}
