import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/client/client_bloc.dart';
import '../../../domain/cubit/date_range_manager_cubit.dart';
import '../../common_feature/calendar/calendar.dart';

@RoutePage()
class ClientCalendarScreen extends StatelessWidget {
  const ClientCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Calendar(
      userId: context.read<ClientBloc>().clientId,
      initialDateRangeType: DateRangeType.week,
      canEditHealthMeasurement: false,
    );
  }
}
