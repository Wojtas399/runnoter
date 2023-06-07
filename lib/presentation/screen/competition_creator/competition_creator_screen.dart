import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/competition_creator/competition_creator_bloc.dart';
import '../../../domain/repository/competition_repository.dart';
import '../../../domain/service/auth_service.dart';

part 'competition_creator_content.dart';

class CompetitionCreatorScreen extends StatelessWidget {
  const CompetitionCreatorScreen({
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
      create: (BuildContext context) => CompetitionCreatorBloc(
        authService: context.read<AuthService>(),
        competitionRepository: context.read<CompetitionRepository>(),
      ),
      child: child,
    );
  }
}
