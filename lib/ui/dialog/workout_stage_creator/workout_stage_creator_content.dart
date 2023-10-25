import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../component/gap/gap_horizontal_components.dart';
import '../../component/responsive_layout_component.dart';
import '../../cubit/workout_stage_creator/workout_stage_creator_cubit.dart';
import '../../service/navigator_service.dart';
import 'workout_stage_creator_form.dart';

class WorkoutStageCreatorContent extends StatelessWidget {
  const WorkoutStageCreatorContent({super.key});

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
      appBar: const _AppBar(),
      body: SafeArea(
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(24),
          child: const WorkoutStageCreatorFormContent(),
        ),
      ),
    );
  }
}

class _NormalDialog extends StatelessWidget {
  const _NormalDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const _DialogTitle(),
      content: const SizedBox(
        width: 500,
        child: WorkoutStageCreatorFormContent(),
      ),
      actions: [
        TextButton(
          onPressed: popRoute,
          child: Text(Str.of(context).cancel),
        ),
        const _SaveButton(),
      ],
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const _DialogTitle(),
      leading: const CloseButton(),
      actions: const [
        _SaveButton(),
        GapHorizontal16(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _DialogTitle extends StatelessWidget {
  const _DialogTitle();

  @override
  Widget build(BuildContext context) {
    final bool isEditMode = context.select(
      (WorkoutStageCreatorCubit cubit) => cubit.state.isEditMode,
    );

    return Text(
      isEditMode
          ? Str.of(context).workoutStageCreatorScreenTitleEditMode
          : Str.of(context).workoutStageCreatorScreenTitleAddMode,
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    final bool isEditMode = context.select(
      (WorkoutStageCreatorCubit cubit) => cubit.state.isEditMode,
    );
    final bool isButtonDisabled = context.select(
      (WorkoutStageCreatorCubit cubit) => !cubit.state.canSubmit,
    );
    final Widget label = Text(
      isEditMode ? Str.of(context).save : Str.of(context).add,
    );

    return FilledButton(
      onPressed: isButtonDisabled
          ? null
          : context.read<WorkoutStageCreatorCubit>().submit,
      child: label,
    );
  }
}
