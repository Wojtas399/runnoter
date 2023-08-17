import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../domain/bloc/client/client_bloc.dart';
import '../../../domain/entity/user.dart';
import '../../component/gap/gap_components.dart';
import '../../component/responsive_layout_component.dart';
import '../../component/value_with_label_and_icon_component.dart';
import '../../extension/gender_extensions.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';

class ClientDetailsIcon extends StatelessWidget {
  const ClientDetailsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _onPressed(context),
      icon: const Icon(Icons.info),
    );
  }

  void _onPressed(BuildContext context) {
    showDialogDependingOnScreenSize(
      BlocProvider.value(
        value: context.read<ClientBloc>(),
        child: const _Dialog(),
      ),
    );
  }
}

class _Dialog extends StatelessWidget {
  const _Dialog();

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileBody: _FullScreenDialog(),
      desktopBody: _NormalDialog(),
    );
  }
}

class _FullScreenDialog extends StatelessWidget {
  const _FullScreenDialog();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Str.of(context).clientDetailsTitle),
        leading: const CloseButton(),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8),
        child: _ClientDetails(),
      ),
    );
  }
}

class _NormalDialog extends StatelessWidget {
  const _NormalDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Str.of(context).clientDetailsTitle),
      contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      content: const SizedBox(
        width: 500,
        child: _ClientDetails(),
      ),
      actions: [
        TextButton(
          onPressed: popRoute,
          child: Text(Str.of(context).close),
        ),
      ],
    );
  }
}

class _ClientDetails extends StatelessWidget {
  const _ClientDetails();

  @override
  Widget build(BuildContext context) {
    const gap = Gap8();

    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Gender(),
        gap,
        _Name(),
        gap,
        _Surname(),
        gap,
        _Email(),
      ],
    );
  }
}

class _Gender extends StatelessWidget {
  const _Gender();

  @override
  Widget build(BuildContext context) {
    final Gender? gender = context.select(
      (ClientBloc bloc) => bloc.state.gender,
    );

    return ValueWithLabelAndIcon(
      iconData: MdiIcons.genderMaleFemale,
      label: Str.of(context).gender,
      value: gender?.toUIFormat(context) ?? '',
    );
  }
}

class _Name extends StatelessWidget {
  const _Name();

  @override
  Widget build(BuildContext context) {
    final String? name = context.select((ClientBloc bloc) => bloc.state.name);

    return ValueWithLabelAndIcon(
      iconData: Icons.person_outline_rounded,
      label: Str.of(context).name,
      value: name ?? '--',
    );
  }
}

class _Surname extends StatelessWidget {
  const _Surname();

  @override
  Widget build(BuildContext context) {
    final String? surname = context.select(
      (ClientBloc bloc) => bloc.state.surname,
    );

    return ValueWithLabelAndIcon(
      iconData: Icons.person_outline_rounded,
      label: Str.of(context).surname,
      value: surname ?? '',
    );
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    final String? email = context.select(
      (ClientBloc bloc) => bloc.state.email,
    );

    return ValueWithLabelAndIcon(
      iconData: Icons.email_outlined,
      label: Str.of(context).email,
      value: email ?? '--',
    );
  }
}
