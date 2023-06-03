part of 'blood_tests_screen.dart';

class _BloodTestsList extends StatelessWidget {
  final List<BloodTestsFromYear> bloodTestsSortedByYear;

  const _BloodTestsList({
    required this.bloodTestsSortedByYear,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const _AddNewTestButton(),
            const SizedBox(height: 24),
            ...bloodTestsSortedByYear.asMap().entries.map(
                  (entry) => entry.key == bloodTestsSortedByYear.length - 1
                      ? _ReadingsFromYear(readingsFromYear: entry.value)
                      : Column(
                          children: [
                            _ReadingsFromYear(readingsFromYear: entry.value),
                            const Divider(),
                          ],
                        ),
                ),
          ],
        ),
      ),
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
