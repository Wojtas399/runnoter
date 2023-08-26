import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/client/client_bloc.dart';
import '../../../domain/bloc/mileage/mileage_bloc.dart';
import 'client_stats_content.dart';

@RoutePage()
class ClientStatsScreen extends StatelessWidget {
  const ClientStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MileageBloc(
        userId: context.read<ClientBloc>().clientId,
      )..add(const MileageEventInitialize()),
      child: const ClientStatsContent(),
    );
  }
}
