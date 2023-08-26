import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/client/client_bloc.dart';
import '../../common_feature/calendar/calendar.dart';
import '../../component/calendar/bloc/calendar_component_bloc.dart';

@RoutePage()
class ClientCalendarScreen extends StatelessWidget {
  const ClientCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Calendar(
      userId: context.read<ClientBloc>().clientId,
      initialDateRangeType: CalendarDateRangeType.week,
      canEditHealthMeasurement: false,
    );
  }
}
