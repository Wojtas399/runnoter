import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/workout_creator/workout_creator_bloc.dart';
import '../../../domain/entity/workout.dart';
import '../../component/big_button_component.dart';
import '../../component/body/medium_body_component.dart';
import '../../component/text_field_component.dart';
import '../../service/dialog_service.dart';
import '../../service/utils.dart';
import 'workout_creator_workout_stages.dart';

class WorkoutCreatorContent extends StatelessWidget {
  const WorkoutCreatorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bool confirmationToLeave = await askForConfirmationToLeave(
          areUnsavedChanges: context.read<WorkoutCreatorBloc>().state.canSubmit,
        );
        if (confirmationToLeave) unfocusInputs();
        return confirmationToLeave;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const _AppBarTitle(),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: unfocusInputs,
              child: MediumBody(
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(24),
                  child: const Column(
                    children: [
                      _WorkoutName(),
                      SizedBox(height: 24),
                      WorkoutCreatorWorkoutStages(),
                      SizedBox(height: 40),
                      _SubmitButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    final Workout? workout = context.select(
      (WorkoutCreatorBloc bloc) => bloc.state.workout,
    );
    return Text(
      workout == null
          ? Str.of(context).workoutCreatorNewWorkoutTitle
          : Str.of(context).workoutCreatorEditWorkoutTitle,
    );
  }
}

class _WorkoutName extends StatefulWidget {
  const _WorkoutName();

  @override
  State<StatefulWidget> createState() => _WorkoutNameState();
}

class _WorkoutNameState extends State<_WorkoutName> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    final String? workoutName =
        context.read<WorkoutCreatorBloc>().state.workoutName;
    if (workoutName != null) _controller.text = workoutName;
    _controller.addListener(_onChanged);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label: Str.of(context).workoutCreatorWorkoutName,
      isRequired: true,
      controller: _controller,
      maxLength: 100,
    );
  }

  void _onChanged() {
    context.read<WorkoutCreatorBloc>().add(
          WorkoutCreatorEventWorkoutNameChanged(workoutName: _controller.text),
        );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final Workout? workout = context.select(
      (WorkoutCreatorBloc bloc) => bloc.state.workout,
    );
    final bool isDisabled = context.select(
      (WorkoutCreatorBloc bloc) => !bloc.state.canSubmit,
    );

    return BigButton(
      label: workout != null
          ? Str.of(context).workoutCreatorEditWorkoutButton
          : Str.of(context).workoutCreatorCreateWorkoutButton,
      isDisabled: isDisabled,
      onPressed: () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<WorkoutCreatorBloc>().add(const WorkoutCreatorEventSubmit());
  }
}
