import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/workout_stage_creator/workout_stage_creator_bloc.dart';
import '../../component/gap_components.dart';
import '../../component/responsive_layout_component.dart';
import '../../service/navigator_service.dart';
import '../../service/utils.dart';
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
        child: GestureDetector(
          onTap: unfocusInputs,
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(24),
            child: const WorkoutStageCreatorFormContent(),
          ),
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
        Gap16(),
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
      (WorkoutStageCreatorBloc bloc) => bloc.state.isEditMode,
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
      (WorkoutStageCreatorBloc bloc) => bloc.state.isEditMode,
    );
    final bool isButtonDisabled = context.select(
      (WorkoutStageCreatorBloc bloc) => bloc.state.isSubmitButtonDisabled,
    );
    final Widget label = Text(
      isEditMode ? Str.of(context).save : Str.of(context).add,
    );

    return FilledButton(
      onPressed: isButtonDisabled ? null : () => _onPressed(context),
      child: label,
    );
  }

  void _onPressed(BuildContext context) {
    context.read<WorkoutStageCreatorBloc>().add(
          const WorkoutStageCreatorEventSubmit(),
        );
  }
}
