import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/races/races_cubit.dart';
import '../../../domain/entity/race.dart';
import '../../../domain/repository/race_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/empty_content_info_component.dart';
import '../../component/loading_info_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/text/label_text_components.dart';
import '../../component/text/title_text_components.dart';
import '../../config/navigation/router.dart';
import '../../formatter/date_formatter.dart';
import '../../formatter/run_status_formatter.dart';
import '../../service/navigator_service.dart';

part 'races_content.dart';
part 'races_list.dart';

@RoutePage()
class RacesScreen extends StatelessWidget {
  const RacesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _CubitProvider(
      child: SafeArea(
        child: _Content(),
      ),
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
      create: (BuildContext context) => RacesCubit(
        authService: context.read<AuthService>(),
        raceRepository: context.read<RaceRepository>(),
      )..initialize(),
      child: child,
    );
  }
}
