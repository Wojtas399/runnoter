part of 'blood_tests_screen.dart';

class _BloodTestsList extends StatelessWidget {
  const _BloodTestsList();

  @override
  Widget build(BuildContext context) {
    final List<BloodTestsFromYear>? bloodTestsByYear = context.select(
      (BloodTestsCubit cubit) => cubit.state,
    );

    if (bloodTestsByYear == null) {
      return const _LoadingContent();
    } else if (bloodTestsByYear.isEmpty) {
      return const _EmptyListContent();
    } else {
      return Column(
        children: bloodTestsByYear
            .asMap()
            .entries
            .map(
              (entry) => entry.key == bloodTestsByYear.length - 1
                  ? _ReadingsFromYear(readingsFromYear: entry.value)
                  : Column(
                      children: [
                        _ReadingsFromYear(readingsFromYear: entry.value),
                        const Divider(),
                      ],
                    ),
            )
            .toList(),
      );
    }
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

class _EmptyListContent extends StatelessWidget {
  const _EmptyListContent();

  @override
  Widget build(BuildContext context) {
    return EmptyContentInfo(
      icon: Icons.water_drop_outlined,
      title: Str.of(context).bloodTestsNoReadingsTitle,
      subtitle: Str.of(context).bloodTestsNoReadingsMessage,
    );
  }
}

class _ReadingsFromYear extends StatelessWidget {
  final BloodTestsFromYear readingsFromYear;

  const _ReadingsFromYear({
    required this.readingsFromYear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleLarge(
            readingsFromYear.year.toString(),
          ),
          const SizedBox(height: 16),
          ...readingsFromYear.bloodTests.map(
            (BloodTest test) => _TestItem(
              bloodTest: test,
              onPressed: () {
                _onPressed(context, test.id);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onPressed(BuildContext context, String bloodTestId) {
    navigateTo(
      context: context,
      route: BloodTestPreviewRoute(
        bloodTestId: bloodTestId,
      ),
    );
  }
}

class _TestItem extends StatelessWidget {
  final BloodTest bloodTest;
  final VoidCallback? onPressed;

  const _TestItem({
    required this.bloodTest,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 16),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            bloodTest.date.toDateWithDots(),
          ),
        ),
      ),
    );
  }
}
