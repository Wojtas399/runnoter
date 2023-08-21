import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/client/client_bloc.dart';
import 'client_content.dart';

@RoutePage()
class ClientScreen extends StatelessWidget {
  final String? clientId;

  const ClientScreen({super.key, @PathParam('clientId') this.clientId});

  @override
  Widget build(BuildContext context) {
    return clientId == null
        ? const Text('Client id not found')
        : BlocProvider(
            create: (_) => ClientBloc(clientId: clientId!)
              ..add(const ClientEventInitialize()),
            child: const ClientContent(),
          );
  }
}
