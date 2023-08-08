import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/clients/clients_cubit.dart';
import '../../component/empty_content_info_component.dart';

@RoutePage()
class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClientsCubit()..initialize(),
      child: const _Clients(),
    );
  }
}

class _Clients extends StatelessWidget {
  const _Clients();

  @override
  Widget build(BuildContext context) {
    final List<Client>? clients = context.select(
      (ClientsCubit cubit) => cubit.state,
    );

    return switch (clients) {
      null => const CircularProgressIndicator(),
      [] => const EmptyContentInfo(title: 'No clients'),
      [...] => ListView.builder(
          itemCount: clients.length,
          itemBuilder: (_, int itemIndex) {
            final Client client = clients[itemIndex];
            return Text('${client.name} ${client.surname}');
          },
        ),
    };
  }
}
