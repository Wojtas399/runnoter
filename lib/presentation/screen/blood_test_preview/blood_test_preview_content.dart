import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/blood_parameter.dart';
import '../../../domain/cubit/blood_test_preview/blood_test_preview_cubit.dart';
import '../../../domain/entity/user.dart';
import '../../component/blood_parameter_results_list_component.dart';
import '../../component/body/medium_body_component.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/loading_info_component.dart';
import '../../component/text/title_text_components.dart';
import '../../extension/context_extensions.dart';
import '../../formatter/date_formatter.dart';
import 'blood_test_preview_actions.dart';

class BloodTestPreviewContent extends StatelessWidget {
  const BloodTestPreviewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: _AppBar(),
      body: SafeArea(
        child: MediumBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DateSection(),
              Expanded(
                child: _Results(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      centerTitle: true,
      title: Text(Str.of(context).bloodTestPreviewTitle),
      actions: context.isMobileSize
          ? const [
              BloodTestPreviewActions(),
              GapHorizontal8(),
            ]
          : null,
    );
  }
}

class _DateSection extends StatelessWidget {
  const _DateSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const _Date(),
          if (!context.isMobileSize) const BloodTestPreviewActions(),
        ],
      ),
    );
  }
}

class _Date extends StatelessWidget {
  const _Date();

  @override
  Widget build(BuildContext context) {
    final DateTime? date = context.select(
      (BloodTestPreviewCubit cubit) => cubit.state.date,
    );

    return TitleLarge(date?.toFullDate(context.languageCode) ?? '--');
  }
}

class _Results extends StatelessWidget {
  const _Results();

  @override
  Widget build(BuildContext context) {
    final Gender? gender = context.select(
      (BloodTestPreviewCubit cubit) => cubit.state.gender,
    );
    final List<BloodParameterResult>? parameterResults = context.select(
      (BloodTestPreviewCubit cubit) => cubit.state.parameterResults,
    );

    return gender == null
        ? const LoadingInfo()
        : BloodParameterResultsList(
            gender: gender,
            parameterResults: parameterResults,
          );
  }
}
