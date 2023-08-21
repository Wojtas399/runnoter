import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/cubit/blood_tests_cubit.dart';
import '../../config/navigation/router.dart';
import '../../service/navigator_service.dart';
import '../big_button_component.dart';
import '../body/medium_body_component.dart';
import '../empty_content_info_component.dart';
import '../gap/gap_components.dart';
import '../loading_info_component.dart';
import '../padding/paddings_24.dart';
import '../responsive_layout_component.dart';
import 'blood_tests_list.dart';

class BloodTestsContent extends StatelessWidget {
  const BloodTestsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const MediumBody(
      child: Paddings24(
        child: ResponsiveLayout(
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
    return const Column(
      children: [
        _AddBloodTestButton(),
        Gap24(),
        Expanded(
          child: _BloodTests(),
        ),
      ],
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
      [] => EmptyContentInfo(
          icon: Icons.water_drop_outlined,
          title: Str.of(context).bloodTestsNoTestsTitle,
          subtitle: Str.of(context).bloodTestsNoTestsMessage,
        ),
      [...] => BloodTestsList(bloodTestsSortedByYear: bloodTestsSortedByYear),
    };
  }
}