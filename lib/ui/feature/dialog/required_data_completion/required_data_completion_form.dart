import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../data/entity/user.dart';
import '../../../../domain/cubit/required_data_completion/required_data_completion_cubit.dart';
import '../../../component/date_of_birth_picker_component.dart';
import '../../../component/form_text_field_component.dart';
import '../../../component/gap/gap_components.dart';
import '../../../component/two_options_component.dart';
import '../../../service/utils.dart';

class RequiredDataCompletionForm extends StatelessWidget {
  const RequiredDataCompletionForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _AccountType(),
        Gap16(),
        _Gender(),
        Gap24(),
        _Name(),
        Gap24(),
        _Surname(),
        Gap24(),
        _DateOfBirth(),
      ],
    );
  }
}

class _AccountType extends StatelessWidget {
  const _AccountType();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    final AccountType? selectedAccountType = context.select(
      (RequiredDataCompletionCubit cubit) => cubit.state.accountType,
    );

    return selectedAccountType == null
        ? const SizedBox()
        : TwoOptions<AccountType>(
            label: str.accountType,
            selectedValue: selectedAccountType,
            option1: OptionParams(label: str.runner, value: AccountType.runner),
            option2: OptionParams(label: str.coach, value: AccountType.coach),
            onChanged:
                context.read<RequiredDataCompletionCubit>().accountTypeChanged,
          );
  }
}

class _Gender extends StatelessWidget {
  const _Gender();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    final Gender? selectedGender = context.select(
      (RequiredDataCompletionCubit cubit) => cubit.state.gender,
    );

    return selectedGender == null
        ? const SizedBox()
        : TwoOptions<Gender>(
            label: str.gender,
            selectedValue: selectedGender,
            option1: OptionParams(label: str.male, value: Gender.male),
            option2: OptionParams(label: str.female, value: Gender.female),
            onChanged:
                context.read<RequiredDataCompletionCubit>().genderChanged,
          );
  }
}

class _Name extends StatelessWidget {
  const _Name();

  @override
  Widget build(BuildContext context) {
    final bool isValid = context.select(
      (RequiredDataCompletionCubit cubit) => cubit.state.isNameValid,
    );
    final str = Str.of(context);

    return FormTextField(
      icon: Icons.person,
      label: str.name,
      isRequired: true,
      textInputAction: TextInputAction.done,
      onChanged: context.read<RequiredDataCompletionCubit>().nameChanged,
      onTapOutside: (_) => unfocusInputs(),
      onSubmitted: (_) => _onSubmitted(context),
      validator: (_) => !isValid ? str.invalidNameOrSurnameMessage : null,
    );
  }
}

class _Surname extends StatelessWidget {
  const _Surname();

  @override
  Widget build(BuildContext context) {
    final bool isValid = context.select(
      (RequiredDataCompletionCubit cubit) => cubit.state.isSurnameValid,
    );
    final str = Str.of(context);

    return FormTextField(
      icon: Icons.person,
      label: str.surname,
      isRequired: true,
      textInputAction: TextInputAction.done,
      onChanged: context.read<RequiredDataCompletionCubit>().surnameChanged,
      onSubmitted: (_) => _onSubmitted(context),
      validator: (_) => !isValid ? str.invalidNameOrSurnameMessage : null,
    );
  }
}

class _DateOfBirth extends StatelessWidget {
  const _DateOfBirth();

  @override
  Widget build(BuildContext context) {
    return DateOfBirthPicker(
      onDatePicked:
          context.read<RequiredDataCompletionCubit>().dateOfBirthChanged,
    );
  }
}

void _onSubmitted(BuildContext context) {
  final cubit = context.read<RequiredDataCompletionCubit>();
  if (cubit.state.canSubmit) cubit.submit();
}
