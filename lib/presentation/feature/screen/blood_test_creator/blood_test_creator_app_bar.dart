import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/cubit/blood_test_creator/blood_test_creator_cubit.dart';
import '../../../component/gap/gap_horizontal_components.dart';

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
      (BloodTestCreatorCubit cubit) => cubit.state.bloodTest != null,
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
      (BloodTestCreatorCubit cubit) => !cubit.state.canSubmit,
    );
    final bool isEditMode = context.select(
      (BloodTestCreatorCubit cubit) => cubit.state.bloodTest != null,
    );

    return FilledButton(
      onPressed:
          isDisabled ? null : context.read<BloodTestCreatorCubit>().submit,
      child: Text(
        isEditMode ? Str.of(context).save : Str.of(context).add,
      ),
    );
  }
}
