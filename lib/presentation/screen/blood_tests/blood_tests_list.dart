import 'package:flutter/material.dart';

import '../../../domain/bloc/blood_tests/blood_tests_cubit.dart';
import '../../../domain/entity/blood_test.dart';
import '../../component/card_body_component.dart';
import '../../component/responsive_layout_component.dart';
import '../../component/text/title_text_components.dart';
import '../../config/navigation/router.dart';
import '../../formatter/date_formatter.dart';
import '../../service/navigator_service.dart';

class BloodTestsList extends StatelessWidget {
  final List<BloodTestsFromYear> bloodTestsSortedByYear;

  const BloodTestsList({
    super.key,
    required this.bloodTestsSortedByYear,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: bloodTestsSortedByYear.length,
      separatorBuilder: (_, int index) => const ResponsiveLayout(
        mobileBody: Divider(height: 32),
        desktopBody: SizedBox(height: 24),
      ),
      itemBuilder: (_, int itemIndex) {
        final Widget tests = _TestsFromYear(
          testsFromYear: bloodTestsSortedByYear[itemIndex],
        );
        return ResponsiveLayout(
          mobileBody: tests,
          desktopBody: CardBody(child: tests),
        );
      },
    );
  }
}

class _TestsFromYear extends StatelessWidget {
  final BloodTestsFromYear testsFromYear;

  const _TestsFromYear({
    required this.testsFromYear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleLarge(testsFromYear.year.toString()),
        const SizedBox(height: 16),
        ...testsFromYear.bloodTests.map(
          (BloodTest test) => _TestItem(bloodTest: test),
        ),
      ],
    );
  }
}

class _TestItem extends StatelessWidget {
  final BloodTest bloodTest;

  const _TestItem({
    required this.bloodTest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 16),
      child: ElevatedButton(
        onPressed: _onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: TitleMedium(bloodTest.date.toDateWithDots()),
        ),
      ),
    );
  }

  void _onPressed() {
    navigateTo(
      BloodTestPreviewRoute(bloodTestId: bloodTest.id),
    );
  }
}
