import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/races/races_cubit.dart';
import '../../../domain/repository/race_repository.dart';
import '../../../domain/service/auth_service.dart';
import 'races_content.dart';

@RoutePage()
class RacesScreen extends StatelessWidget {
  const RacesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _CubitProvider(
      child: SafeArea(
        child: RacesContent(),
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
