import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/blood_test_creator/blood_test_creator_bloc.dart';
import '../../component/gap/gap_horizontal_components.dart';

class BloodTestCreatorAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const BloodTestCreatorAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      title: const _AppBarTitle(),
      actions: const [
        _SubmitButton(),
        GapHorizontal16(),
      ],
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    final bool isEditMode = context.select(
      (BloodTestCreatorBloc bloc) => bloc.state.bloodTest != null,
    );
    final String title = switch (isEditMode) {
      true => Str.of(context).bloodTestCreatorScreenTitleEditMode,
      false => Str.of(context).bloodTestCreatorScreenTitleAddMode,
    };
    return Text(title);
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (BloodTestCreatorBloc bloc) => !bloc.state.canSubmit,
    );
    final bool isEditMode = context.select(
      (BloodTestCreatorBloc bloc) => bloc.state.bloodTest != null,
    );

    return FilledButton(
      onPressed: isDisabled ? null : () => _onPressed(context),
      child: Text(
        isEditMode ? Str.of(context).save : Str.of(context).add,
      ),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<BloodTestCreatorBloc>().add(
          const BloodTestCreatorEventSubmit(),
        );
  }
}
