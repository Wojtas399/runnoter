import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../data/entity/user.dart';
import '../../../component/gap/gap_components.dart';
import '../../../component/responsive_layout_component.dart';
import '../../../component/text/body_text_components.dart';
import '../../../service/navigator_service.dart';
import 'cubit/identities/profile_identities_cubit.dart';

class ProfileGenderDialog extends StatelessWidget {
  const ProfileGenderDialog({super.key});

  @override
  Widget build(BuildContext context) => const ResponsiveLayout(
        mobileBody: _FullScreenDialog(),
        desktopBody: _NormalDialog(),
      );
}

class _NormalDialog extends StatelessWidget {
  const _NormalDialog();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return AlertDialog(
      title: Text(str.gender),
      contentPadding: const EdgeInsets.symmetric(vertical: 24),
      content: const SizedBox(
        width: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(),
            Gap16(),
            _OptionsToSelect(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: popRoute,
          child: Text(str.close),
        ),
      ],
    );
  }
}

class _FullScreenDialog extends StatelessWidget {
  const _FullScreenDialog();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Str.of(context).gender),
        leading: const CloseButton(),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(),
              Gap16(),
              _OptionsToSelect(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: BodyLarge(Str.of(context).genderSelection),
    );
  }
}

class _OptionsToSelect extends StatelessWidget {
  const _OptionsToSelect();

  @override
  Widget build(BuildContext context) {
    final Gender? selectedGender = context.select(
      (ProfileIdentitiesCubit cubit) => cubit.state.gender,
    );
    final str = Str.of(context);

    return Column(
      children: [
        RadioListTile<Gender>(
          title: Text(str.male),
          value: Gender.male,
          groupValue: selectedGender,
          onChanged: (Gender? gender) => _onGenderChanged(context, gender),
        ),
        RadioListTile<Gender>(
          title: Text(str.female),
          value: Gender.female,
          groupValue: selectedGender,
          onChanged: (Gender? gender) => _onGenderChanged(context, gender),
        ),
      ],
    );
  }

  void _onGenderChanged(BuildContext context, Gender? newGender) {
    if (newGender != null) {
      context.read<ProfileIdentitiesCubit>().updateGender(newGender);
    }
  }
}
