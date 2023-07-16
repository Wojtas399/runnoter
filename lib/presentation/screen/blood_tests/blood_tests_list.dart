part of 'blood_tests_screen.dart';

class _BloodTestsList extends StatelessWidget {
  final List<BloodTestsFromYear> bloodTestsSortedByYear;

  const _BloodTestsList({
    required this.bloodTestsSortedByYear,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (_, int itemIndex) => const Divider(),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      itemCount: bloodTestsSortedByYear.length,
      itemBuilder: (_, int itemIndex) => _ReadingsFromYear(
        readingsFromYear: bloodTestsSortedByYear[itemIndex],
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
              onPressed: () => _onPressed(test.id),
            ),
          ),
        ],
      ),
    );
  }

  void _onPressed(String bloodTestId) {
    navigateTo(
      BloodTestPreviewRoute(bloodTestId: bloodTestId),
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
          child: TitleMedium(
            bloodTest.date.toDateWithDots(),
          ),
        ),
      ),
    );
  }
}
