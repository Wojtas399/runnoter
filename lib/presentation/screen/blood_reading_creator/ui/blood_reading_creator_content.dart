part of 'blood_reading_creator_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood test creator'),
        actions: const [
          _SubmitButton(),
          SizedBox(width: 16),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          unfocusInputs();
        },
        child: const Column(
          children: [
            _ReadingDate(),
            Expanded(
              child: _AllParameters(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (BloodReadingCreatorBloc bloc) => !bloc.state.areDataValid,
    );

    return FilledButton(
      onPressed: isDisabled
          ? null
          : () {
              _onPressed(context);
            },
      child: Text(
        Str.of(context).save,
      ),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<BloodReadingCreatorBloc>().add(
          const BloodReadingCreatorEventSubmit(),
        );
  }
}
