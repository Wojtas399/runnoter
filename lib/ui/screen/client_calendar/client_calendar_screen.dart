import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_feature/calendar/calendar.dart';
import '../../cubit/client/client_cubit.dart';

@RoutePage()
class ClientCalendarScreen extends StatelessWidget {
  const ClientCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Calendar(userId: context.read<ClientCubit>().clientId);
  }
}
