import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../data/entity/blood_test.dart';
import '../../../component/body/medium_body_component.dart';
import '../../../component/card_body_component.dart';
import '../../../component/empty_content_info_component.dart';
import '../../../component/gap/gap_components.dart';
import '../../../component/loading_info_component.dart';
import '../../../component/responsive_layout_component.dart';
import '../../../component/text/title_text_components.dart';
import '../../../config/navigation/router.dart';
import '../../../cubit/blood_tests_cubit.dart';
import '../../../extension/context_extensions.dart';
import '../../../formatter/date_formatter.dart';
import '../../../service/navigator_service.dart';

class BloodTests extends StatelessWidget {
  final String userId;

  const BloodTests({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BloodTestsCubit(userId: userId)..initialize(),
      child: const MediumBody(
        child: _BloodTests(),
      ),
    );
  }
}

class _BloodTests extends StatelessWidget {
  const _BloodTests();

  @override
  Widget build(BuildContext context) {
    final List<BloodTestsFromYear>? bloodTestsSortedByYear = context.select(
      (BloodTestsCubit cubit) => cubit.state,
    );

    return switch (bloodTestsSortedByYear) {
      null => const LoadingInfo(),
      [] => RefreshIndicator(
          onRefresh: context.read<BloodTestsCubit>().refresh,
          child: const _NoTestsContent(),
        ),
      [...] => RefreshIndicator(
          onRefresh: context.read<BloodTestsCubit>().refresh,
          child: _BloodTestsList(
            bloodTestsSortedByYear: bloodTestsSortedByYear,
          ),
        ),
    };
  }
}

class _NoTestsContent extends StatelessWidget {
  const _NoTestsContent();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final str = Str.of(context);

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              maxHeight: double.infinity,
            ),
            child: EmptyContentInfo(
              icon: Icons.water_drop_outlined,
              title: str.bloodTestsNoTestsTitle,
              subtitle: str.bloodTestsNoTestsMessage,
            ),
          ),
        );
      },
    );
  }
}

class _BloodTestsList extends StatelessWidget {
  final List<BloodTestsFromYear> bloodTestsSortedByYear;

  const _BloodTestsList({required this.bloodTestsSortedByYear});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: bloodTestsSortedByYear.length,
      padding: EdgeInsets.fromLTRB(24, 24, 24, context.isMobileSize ? 144 : 24),
      separatorBuilder: (_, int index) => const ResponsiveLayout(
        mobileBody: Divider(height: 32),
        desktopBody: Gap24(),
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
        const Gap16(),
        ...testsFromYear.elements.map(
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
        onPressed: () => _onPressed(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: TitleMedium(bloodTest.date.toDateWithDots()),
        ),
      ),
    );
  }

  void _onPressed(BuildContext context) {
    navigateTo(BloodTestPreviewRoute(
      userId: context.read<BloodTestsCubit>().userId,
      bloodTestId: bloodTest.id,
    ));
  }
}
