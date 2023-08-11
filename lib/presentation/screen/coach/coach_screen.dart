import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/coach/coach_bloc.dart';
import '../../../domain/entity/user_basic_info.dart';
import '../../component/body/medium_body_component.dart';
import 'coach_received_coaching_requests.dart';

@RoutePage()
class CoachScreen extends StatelessWidget {
  const CoachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CoachBloc()..add(const CoachEventInitialize()),
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return const MediumBody(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: _Coach(),
      ),
    );
  }
}

class _Coach extends StatelessWidget {
  const _Coach();

  @override
  Widget build(BuildContext context) {
    final UserBasicInfo? coach = context.select(
      (CoachBloc bloc) => bloc.state.coach,
    );

    return coach != null
        ? Text(coach.name)
        : const CoachReceivedCoachingRequests();
  }
}
