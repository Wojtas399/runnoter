import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/client/client_bloc.dart';
import '../../../domain/bloc/health_stats/health_stats_bloc.dart';
import '../../../domain/bloc/mileage/mileage_bloc.dart';
import 'client_stats_content.dart';

@RoutePage()
class ClientStatsScreen extends StatelessWidget {
  const ClientStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String clientId = context.read<ClientBloc>().clientId;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MileageBloc(userId: clientId)
            ..add(const MileageEventInitialize()),
        ),
        BlocProvider(
          create: (_) => HealthStatsBloc(userId: clientId)
            ..add(const HealthStatsEventInitialize()),
        ),
      ],
      child: const ClientStatsContent(),
    );
  }
}
