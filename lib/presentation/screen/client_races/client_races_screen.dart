import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/client/client_bloc.dart';
import '../../component/races/races_component.dart';

@RoutePage()
class ClientRacesScreen extends StatelessWidget {
  const ClientRacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Races(userId: context.read<ClientBloc>().clientId);
  }
}
