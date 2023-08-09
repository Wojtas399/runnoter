import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/user_basic_info.dart';
import '../../../domain/cubit/clients_cubit.dart';
import '../../component/big_button_component.dart';
import '../../component/body/medium_body_component.dart';
import '../../component/empty_content_info_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/responsive_layout_component.dart';
import '../../dialog/users_search/users_search_dialog.dart';
import '../../service/dialog_service.dart';

@RoutePage()
class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClientsCubit()..initialize(),
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return MediumBody(
      child: Paddings24(
        child: ResponsiveLayout(
          mobileBody: const _Clients(),
          desktopBody: Column(
            children: [
              BigButton(
                label: Str.of(context).clientsSearchUsers,
                onPressed: () => showDialogDependingOnScreenSize(
                  const UsersSearchDialog(),
                ),
              ),
              const Gap24(),
              const Expanded(
                child: _Clients(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Clients extends StatelessWidget {
  const _Clients();

  @override
  Widget build(BuildContext context) {
    final List<UserBasicInfo>? clients = context.select(
      (ClientsCubit cubit) => cubit.state,
    );

    return switch (clients) {
      null => const CircularProgressIndicator(),
      [] => const EmptyContentInfo(title: 'No clients'),
      [...] => ListView.builder(
          itemCount: clients.length,
          itemBuilder: (_, int itemIndex) {
            final UserBasicInfo client = clients[itemIndex];
            return Text('${client.name} ${client.surname}');
          },
        ),
    };
  }
}
