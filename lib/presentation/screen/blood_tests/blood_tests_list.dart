import 'package:flutter/material.dart';

import '../../../domain/bloc/blood_tests/blood_tests_cubit.dart';
import '../../../domain/entity/blood_test.dart';
import '../../component/card_body_component.dart';
import '../../component/responsive_layout_component.dart';
import '../../component/text/title_text_components.dart';
import '../../config/navigation/router.dart';
import '../../extension/context_extensions.dart';
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
      padding: const EdgeInsets.all(24),
      itemCount: bloodTestsSortedByYear.length,
      itemBuilder: (_, int itemIndex) {
        final Widget tests = _TestsFromYear(
          testsFromYear: bloodTestsSortedByYear[itemIndex],
        );
        return ResponsiveLayout(
          mobileBody: tests,
          tabletBody: CardBody(child: tests),
          desktopBody: CardBody(child: tests),
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          context.isMobileSize
              ? const Divider(height: 32)
              : const SizedBox(height: 24),
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
          (BloodTest test) => _TestItem(
            bloodTest: test,
            onPressed: () => _onPressed(test.id),
          ),
        ),
      ],
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
          child: TitleMedium(bloodTest.date.toDateWithDots()),
        ),
      ),
    );
  }
}
