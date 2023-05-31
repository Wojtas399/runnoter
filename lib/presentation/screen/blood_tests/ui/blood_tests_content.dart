part of 'blood_tests_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final List<BloodTestsFromYear>? bloodTestsSortedByYear = context.select(
      (BloodTestsCubit cubit) => cubit.state,
    );

    return SafeArea(
      child: switch (bloodTestsSortedByYear) {
        null => const _LoadingContent(),
        [] => const _NoTestsInfo(),
        [...] => _BloodTestsList(
            bloodTestsSortedByYear: bloodTestsSortedByYear,
          )
      },
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _NoTestsInfo extends StatelessWidget {
  const _NoTestsInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EmptyContentInfo(
          icon: Icons.water_drop_outlined,
          title: Str.of(context).bloodTestsNoReadingsTitle,
          subtitle: Str.of(context).bloodTestsNoReadingsMessage,
        ),
        const SizedBox(height: 32),
        const _AddNewTestButton(
          buttonType: _AddNewTestButtonType.filled,
        ),
      ],
    );
  }
}

class _AddNewTestButton extends StatelessWidget {
  final _AddNewTestButtonType buttonType;

  const _AddNewTestButton({
    this.buttonType = _AddNewTestButtonType.outlined,
  });

  @override
  Widget build(BuildContext context) {
    return _createAppropriateButton(
      label: Str.of(context).bloodTestsAddNewBloodTest,
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  Widget _createAppropriateButton({
    required String label,
    required VoidCallback onPressed,
  }) =>
      switch (buttonType) {
        _AddNewTestButtonType.outlined => OutlinedButton(
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add),
                const SizedBox(width: 8),
                Text(label),
              ],
            ),
          ),
        _AddNewTestButtonType.filled => FilledButton(
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add),
                const SizedBox(width: 8),
                Text(label),
              ],
            ),
          ),
      };

  void _onPressed(BuildContext context) {
    navigateTo(
      context: context,
      route: const BloodTestCreatorRoute(),
    );
  }
}

enum _AddNewTestButtonType {
  outlined,
  filled,
}
