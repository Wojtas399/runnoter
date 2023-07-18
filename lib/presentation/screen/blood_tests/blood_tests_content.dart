import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/bloc/blood_tests/blood_tests_cubit.dart';
import '../../component/big_button_component.dart';
import '../../component/empty_content_info_component.dart';
import '../../component/loading_info_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/responsive_layout_component.dart';
import '../../config/body_sizes.dart';
import '../../config/navigation/router.dart';
import '../../service/navigator_service.dart';
import 'blood_tests_list.dart';

class BloodTestsContent extends StatelessWidget {
  const BloodTestsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: GetIt.I.get<BodySizes>().mediumBodyWidth,
        ),
        child: const ResponsiveLayout(
          mobileBody: _BloodTests(),
          desktopBody: _DesktopContent(),
        ),
      ),
    );
  }
}

class _DesktopContent extends StatelessWidget {
  const _DesktopContent();

  @override
  Widget build(BuildContext context) {
    return const Paddings24(
      child: Column(
        children: [
          _AddBloodTestButton(),
          Expanded(
            child: _BloodTests(),
          ),
        ],
      ),
    );
  }
}

class _AddBloodTestButton extends StatelessWidget {
  const _AddBloodTestButton();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BigButton(
          label: Str.of(context).bloodTestsAddNewBloodTest,
          onPressed: () => navigateTo(BloodTestCreatorRoute()),
        ),
      ],
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
      [] => const _NoTestsInfo(),
      [...] => BloodTestsList(bloodTestsSortedByYear: bloodTestsSortedByYear),
    };
  }
}

class _NoTestsInfo extends StatelessWidget {
  const _NoTestsInfo();

  @override
  Widget build(BuildContext context) {
    return Paddings24(
      child: EmptyContentInfo(
        icon: Icons.water_drop_outlined,
        title: Str.of(context).bloodTestsNoTestsTitle,
        subtitle: Str.of(context).bloodTestsNoTestsMessage,
      ),
    );
  }
}
