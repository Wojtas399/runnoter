import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/competitions/competitions_cubit.dart';
import '../../../domain/repository/competition_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/big_button_component.dart';
import '../../config/navigation/routes.dart';
import '../../service/navigator_service.dart';

class CompetitionsScreen extends StatelessWidget {
  const CompetitionsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _CubitProvider(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            BigButton(
              label: 'Nowe zawody',
              onPressed: () {
                navigateTo(
                  context: context,
                  route: const CompetitionCreatorRoute(),
                );
              },
            ),
          ],
        ),
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
