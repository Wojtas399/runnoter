import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_feature/races/races.dart';
import '../../cubit/client/client_cubit.dart';

@RoutePage()
class ClientRacesScreen extends StatelessWidget {
  const ClientRacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Races(userId: context.read<ClientCubit>().clientId);
  }
}
