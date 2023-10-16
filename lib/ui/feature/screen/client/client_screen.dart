import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/calendar/calendar_cubit.dart';
import '../../../cubit/client/client_cubit.dart';
import '../../../cubit/date_range_manager_cubit.dart';
import 'client_content.dart';

@RoutePage()
class ClientScreen extends StatelessWidget {
  final String? clientId;

  const ClientScreen({super.key, @PathParam('clientId') this.clientId});

  @override
  Widget build(BuildContext context) {
    return clientId == null
        ? const Text('Client id not found')
        : MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => ClientCubit(clientId: clientId!)..initialize(),
              ),
              BlocProvider(
                create: (_) => CalendarCubit()..initialize(DateRangeType.week),
              ),
            ],
            child: const ClientContent(),
          );
  }
}
