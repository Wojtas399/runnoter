import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/mileage_stats/mileage_stats_bloc.dart';
import '../../../domain/cubit/client/client_cubit.dart';
import '../../../domain/cubit/health_stats/health_stats_cubit.dart';
import 'client_stats_content.dart';

@RoutePage()
class ClientStatsScreen extends StatelessWidget {
  const ClientStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String clientId = context.read<ClientCubit>().clientId;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MileageStatsBloc(userId: clientId)
            ..add(const MileageStatsEventInitialize()),
        ),
        BlocProvider(
          create: (_) => HealthStatsCubit(userId: clientId)..initialize(),
        ),
      ],
      child: const ClientStatsContent(),
    );
  }
}
