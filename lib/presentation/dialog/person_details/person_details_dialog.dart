import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../domain/cubit/person_details/person_details_cubit.dart';
import '../../../domain/entity/user.dart';
import '../../component/gap/gap_components.dart';
import '../../component/responsive_layout_component.dart';
import '../../component/value_with_label_and_icon_component.dart';
import '../../formatter/date_formatter.dart';
import '../../formatter/gender_formatter.dart';
import '../../service/navigator_service.dart';

enum PersonType { coach, client }

class PersonDetailsDialog extends StatelessWidget {
  final String personId;
  final PersonType personType;

  const PersonDetailsDialog({
    super.key,
    required this.personId,
    required this.personType,
  });

  @override
  Widget build(BuildContext context) {
    final String dialogTitle = switch (personType) {
      PersonType.coach => Str.of(context).personCoachDetailsTitle,
      PersonType.client => Str.of(context).personClientDetailsTitle,
    };

    return BlocProvider(
      create: (_) => PersonDetailsCubit(personId: personId)..initialize(),
      child: ResponsiveLayout(
        mobileBody: _FullScreenDialog(dialogTitle: dialogTitle),
        desktopBody: _NormalDialog(dialogTitle: dialogTitle),
      ),
    );
  }
}

class _FullScreenDialog extends StatelessWidget {
  final String dialogTitle;

  const _FullScreenDialog({required this.dialogTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(dialogTitle),
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
  final String dialogTitle;

  const _NormalDialog({required this.dialogTitle});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(dialogTitle),
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
        _DateOfBirth(),
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
      (PersonDetailsCubit cubit) => cubit.state.gender,
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
    final String? name = context.select(
      (PersonDetailsCubit cubit) => cubit.state.name,
    );

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
      (PersonDetailsCubit cubit) => cubit.state.surname,
    );

    return ValueWithLabelAndIcon(
      iconData: Icons.person_outline_rounded,
      label: Str.of(context).surname,
      value: surname ?? '',
    );
  }
}

class _DateOfBirth extends StatelessWidget {
  const _DateOfBirth();

  @override
  Widget build(BuildContext context) {
    final DateTime? dateOfBirth = context.select(
      (PersonDetailsCubit cubit) => cubit.state.dateOfBirth,
    );

    return ValueWithLabelAndIcon(
      iconData: Icons.cake_outlined,
      label: Str.of(context).dateOfBirth,
      value: dateOfBirth?.toDateWithDots() ?? '',
    );
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    final String? email = context.select(
      (PersonDetailsCubit cubit) => cubit.state.email,
    );

    return ValueWithLabelAndIcon(
      iconData: Icons.email_outlined,
      label: Str.of(context).email,
      value: email ?? '--',
    );
  }
}
