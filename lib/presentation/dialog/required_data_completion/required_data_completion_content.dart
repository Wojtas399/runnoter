import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/required_data_completion/required_data_completion_bloc.dart';
import '../../component/gap/gap_components.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/responsive_layout_component.dart';
import '../../service/navigator_service.dart';
import '../../service/utils.dart';
import 'required_data_completion_form.dart';

class RequiredDataCompletionContent extends StatelessWidget {
  const RequiredDataCompletionContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileBody: _FullScreenDialog(),
      desktopBody: _NormalDialog(),
    );
  }
}

class _NormalDialog extends StatelessWidget {
  const _NormalDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Str.of(context).requiredDataCompletionTitle),
      content: const SizedBox(
        width: 400,
        child: _Content(),
      ),
      actions: [
        TextButton(
          onPressed: () => popRoute(result: false),
          child: Text(Str.of(context).cancel),
        ),
        const _SubmitButton(),
      ],
    );
  }
}

class _FullScreenDialog extends StatelessWidget {
  const _FullScreenDialog();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(onPressed: () => popRoute(result: false)),
        title: Text(Str.of(context).requiredDataCompletionTitle),
        actions: const [
          _SubmitButton(),
          GapHorizontal8(),
        ],
      ),
      body: LayoutBuilder(builder: (_, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: GestureDetector(
            onTap: unfocusInputs,
            child: Container(
              constraints: constraints.copyWith(
                minHeight: constraints.maxHeight,
                maxHeight: double.infinity,
              ),
              padding: const EdgeInsets.all(24),
              color: Colors.transparent,
              child: const _Content(),
            ),
          ),
        );
      }),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(Str.of(context).requiredDataCompletionMessage),
        const Gap24(),
        const RequiredDataCompletionForm(),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (RequiredDataCompletionBloc bloc) => !bloc.state.canSubmit,
    );

    return FilledButton(
      onPressed: isDisabled ? null : () => _onPressed(context),
      child: Text(Str.of(context).save),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<RequiredDataCompletionBloc>().add(
          const RequiredDataCompletionEventSubmit(),
        );
  }
}
