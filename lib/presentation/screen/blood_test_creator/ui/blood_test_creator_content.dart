part of 'blood_test_creator_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
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
      (BloodTestCreatorBloc bloc) => !bloc.state.areDataValid,
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
    context.read<BloodTestCreatorBloc>().add(
          const BloodTestCreatorEventSubmit(),
        );
  }
}
