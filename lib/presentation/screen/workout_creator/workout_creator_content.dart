import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/bloc_status.dart';
import '../../../domain/bloc/workout_creator/workout_creator_bloc.dart';
import '../../../domain/entity/workout.dart';
import '../../component/big_button_component.dart';
import '../../component/body/medium_body_component.dart';
import '../../component/date_selector_component.dart';
import '../../component/form_text_field_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/loading_info_component.dart';
import '../../component/text/title_text_components.dart';
import '../../service/dialog_service.dart';
import '../../service/utils.dart';
import 'workout_creator_workout_stages.dart';

class WorkoutCreatorContent extends StatelessWidget {
  const WorkoutCreatorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await askForConfirmationToLeave(
        areUnsavedChanges: context.read<WorkoutCreatorBloc>().state.canSubmit,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const _AppBarTitle(),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: MediumBody(
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.all(24),
                child: const _Form(),
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

class _Form extends StatelessWidget {
  const _Form();

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (WorkoutCreatorBloc bloc) => bloc.state.status,
    );

    return blocStatus is BlocStatusInitial
        ? const LoadingInfo()
        : const Column(
            children: [
              _Date(),
              Gap24(),
              _WorkoutName(),
              Gap24(),
              WorkoutCreatorWorkoutStages(),
              Gap40(),
              _SubmitButton(),
            ],
          );
  }
}

class _Date extends StatelessWidget {
  const _Date();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleMedium(Str.of(context).date),
        const Gap8(),
        const _DateValue(),
      ],
    );
  }
}

class _DateValue extends StatelessWidget {
  const _DateValue();

  @override
  Widget build(BuildContext context) {
    final DateTime? date = context.select(
      (WorkoutCreatorBloc bloc) => bloc.state.date,
    );

    return DateSelector(
      date: date,
      onDateSelected: (DateTime date) => _onDateSelected(context, date),
    );
  }

  void _onDateSelected(BuildContext context, DateTime date) {
    context.read<WorkoutCreatorBloc>().add(
          WorkoutCreatorEventDateChanged(date: date),
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
    return FormTextField(
      label: Str.of(context).workoutCreatorWorkoutName,
      isRequired: true,
      controller: _controller,
      maxLength: 100,
      textInputAction: TextInputAction.done,
      onTapOutside: (_) => unfocusInputs(),
      onSubmitted: (_) => _onSubmitted(context),
    );
  }

  void _onChanged() {
    context.read<WorkoutCreatorBloc>().add(
          WorkoutCreatorEventWorkoutNameChanged(workoutName: _controller.text),
        );
  }

  void _onSubmitted(BuildContext context) {
    final bloc = context.read<WorkoutCreatorBloc>();
    if (bloc.state.canSubmit) {
      bloc.add(const WorkoutCreatorEventSubmit());
    }
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
