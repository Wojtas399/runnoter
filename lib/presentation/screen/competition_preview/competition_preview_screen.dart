import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/competition_preview/competition_preview_bloc.dart';
import '../../../domain/repository/competition_repository.dart';
import '../../../domain/service/auth_service.dart';

part 'competition_preview_content.dart';

class CompetitionPreviewScreen extends StatelessWidget {
  final String competitionId;

  const CompetitionPreviewScreen({
    super.key,
    required this.competitionId,
  });

  @override
  Widget build(BuildContext context) {
    return _BlocProvider(
      competitionId: competitionId,
      child: const _Content(),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final String competitionId;
  final Widget child;

  const _BlocProvider({
    required this.competitionId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CompetitionPreviewBloc(
        authService: context.read<AuthService>(),
        competitionRepository: context.read<CompetitionRepository>(),
      )..add(
          CompetitionPreviewEventInitialize(
            competitionId: competitionId,
          ),
        ),
      child: child,
    );
  }
}
