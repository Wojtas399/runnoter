part of 'competition_creator_screen.dart';

class _ExpectedDuration extends StatelessWidget {
  const _ExpectedDuration();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleMedium(
          Str.of(context).competitionCreatorExpectedDuration,
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ExpectedDurationValue(),
            _ExpectedDurationButton(),
          ],
        ),
      ],
    );
  }
}

class _ExpectedDurationValue extends StatelessWidget {
  const _ExpectedDurationValue();

  @override
  Widget build(BuildContext context) {
    final Duration? duration = context.select(
      (CompetitionCreatorBloc bloc) => bloc.state.expectedDuration,
    );

    if (duration == null) {
      return const SizedBox();
    }
    return Expanded(
      child: TitleLarge(duration.toString()),
    );
  }
}

class _ExpectedDurationButton extends StatelessWidget {
  const _ExpectedDurationButton();

  @override
  Widget build(BuildContext context) {
    final Duration? duration = context.select(
      (CompetitionCreatorBloc bloc) => bloc.state.expectedDuration,
    );

    if (duration == null) {
      return FilledButton(
        onPressed: () {
          _onPressed(context);
        },
        child: Text(
          Str.of(context).select,
        ),
      );
    }
    return OutlinedButton(
      onPressed: () {
        _onPressed(context);
      },
      child: Text(
        Str.of(context).change,
      ),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    final CompetitionCreatorBloc bloc = context.read<CompetitionCreatorBloc>();
    final Duration? duration = await showDurationPicker(
      context: context,
      initialTime: bloc.state.expectedDuration ?? const Duration(seconds: 0),
    );
    if (duration != null) {
      bloc.add(
        CompetitionCreatorEventExpectedDurationChanged(
          expectedDuration: duration,
        ),
      );
    }
  }
}
