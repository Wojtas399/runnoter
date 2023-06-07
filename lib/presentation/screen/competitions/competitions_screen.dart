import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/competitions/competitions_cubit.dart';
import '../../../domain/entity/competition.dart';
import '../../../domain/repository/competition_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/big_button_component.dart';
import '../../component/empty_content_info_component.dart';
import '../../component/text/label_text_components.dart';
import '../../component/text/title_text_components.dart';
import '../../formatter/date_formatter.dart';
import '../../formatter/run_status_formatter.dart';

part 'competitions_content.dart';
part 'competitions_list.dart';

class CompetitionsScreen extends StatelessWidget {
  const CompetitionsScreen({
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
      create: (BuildContext context) => CompetitionsCubit(
        authService: context.read<AuthService>(),
        competitionRepository: context.read<CompetitionRepository>(),
      )..initialize(),
      child: child,
    );
  }
}
