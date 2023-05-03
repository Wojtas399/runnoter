part of 'workout_status_creator_screen.dart';

class _Comment extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (WorkoutStatusCreatorBloc bloc) => bloc.state.status,
    );
    if (blocStatus is BlocStatusComplete &&
        blocStatus.info == WorkoutStatusCreatorInfo.workoutStatusInitialized) {
      _controller.text =
          context.read<WorkoutStatusCreatorBloc>().state.comment ?? '';
    }

    return TextFieldComponent(
      label: AppLocalizations.of(context)!.workout_status_creator_comment_label,
      maxLength: 100,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      displayCounterText: true,
      controller: _controller,
      onChanged: (String? comment) {
        _onChanged(context, comment);
      },
    );
  }

  void _onChanged(BuildContext context, String? comment) {
    context.read<WorkoutStatusCreatorBloc>().add(
          WorkoutStatusCreatorEventCommentChanged(
            comment: comment,
          ),
        );
  }
}
