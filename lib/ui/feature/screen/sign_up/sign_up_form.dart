import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../data/entity/user.dart';
import '../../../component/date_of_birth_picker_component.dart';
import '../../../component/form_text_field_component.dart';
import '../../../component/gap/gap_components.dart';
import '../../../component/password_text_field_component.dart';
import '../../../component/two_options_component.dart';
import '../../../cubit/sign_up/sign_up_cubit.dart';
import '../../../service/utils.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    const gap = Gap24();

    return const Column(
      children: [
        _AccountType(),
        Gap16(),
        _Gender(),
        gap,
        _Name(),
        gap,
        _Surname(),
        gap,
        _Email(),
        gap,
        _DateOfBirth(),
        gap,
        _Password(),
        gap,
        _PasswordConfirmation(),
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
      (SignUpCubit cubit) => cubit.state.accountType,
    );

    return selectedAccountType == null
        ? const SizedBox()
        : TwoOptions<AccountType>(
            label: str.accountType,
            selectedValue: selectedAccountType,
            option1: OptionParams(label: str.runner, value: AccountType.runner),
            option2: OptionParams(label: str.coach, value: AccountType.coach),
            onChanged: context.read<SignUpCubit>().accountTypeChanged,
          );
  }
}

class _Gender extends StatelessWidget {
  const _Gender();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    final Gender? selectedGender = context.select(
      (SignUpCubit cubit) => cubit.state.gender,
    );

    return selectedGender == null
        ? const SizedBox()
        : TwoOptions<Gender>(
            label: str.gender,
            selectedValue: selectedGender,
            option1: OptionParams(label: str.male, value: Gender.male),
            option2: OptionParams(label: str.female, value: Gender.female),
            onChanged: context.read<SignUpCubit>().genderChanged,
          );
  }
}

class _Name extends StatelessWidget {
  const _Name();

  @override
  Widget build(BuildContext context) {
    final bool isValid = context.select(
      (SignUpCubit cubit) => cubit.state.isNameValid,
    );
    final str = Str.of(context);

    return FormTextField(
      icon: Icons.person,
      label: str.name,
      isRequired: true,
      onChanged: context.read<SignUpCubit>().nameChanged,
      onTapOutside: (_) => unfocusInputs(),
      onSubmitted: (_) => _onFormSubmitted(context),
      validator: (_) => !isValid ? str.invalidNameOrSurnameMessage : null,
    );
  }
}

class _Surname extends StatelessWidget {
  const _Surname();

  @override
  Widget build(BuildContext context) {
    final bool isValid = context.select(
      (SignUpCubit cubit) => cubit.state.isSurnameValid,
    );
    final str = Str.of(context);

    return FormTextField(
      icon: Icons.person,
      label: str.surname,
      isRequired: true,
      onChanged: context.read<SignUpCubit>().surnameChanged,
      onSubmitted: (_) => _onFormSubmitted(context),
      validator: (_) => !isValid ? str.invalidNameOrSurnameMessage : null,
    );
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    final bool isValid = context.select(
      (SignUpCubit cubit) => cubit.state.isEmailValid,
    );
    final str = Str.of(context);

    return FormTextField(
      icon: Icons.email,
      label: str.email,
      isRequired: true,
      keyboardType: TextInputType.emailAddress,
      onChanged: context.read<SignUpCubit>().emailChanged,
      onSubmitted: (_) => _onFormSubmitted(context),
      validator: (_) => !isValid ? str.invalidEmailMessage : null,
    );
  }
}

class _DateOfBirth extends StatelessWidget {
  const _DateOfBirth();

  @override
  Widget build(BuildContext context) {
    return DateOfBirthPicker(
      onDatePicked: context.read<SignUpCubit>().dateOfBirthChanged,
    );
  }
}

class _Password extends StatelessWidget {
  const _Password();

  @override
  Widget build(BuildContext context) {
    final bool isValid = context.select(
      (SignUpCubit cubit) => cubit.state.isPasswordValid,
    );

    return PasswordTextFieldComponent(
      isRequired: true,
      onChanged: context.read<SignUpCubit>().passwordChanged,
      onSubmitted: (_) => _onFormSubmitted(context),
      validator: (_) =>
          !isValid ? Str.of(context).invalidPasswordMessage : null,
    );
  }
}

class _PasswordConfirmation extends StatelessWidget {
  const _PasswordConfirmation();

  @override
  Widget build(BuildContext context) {
    final bool isValid = context.select(
      (SignUpCubit cubit) => cubit.state.isPasswordConfirmationValid,
    );

    return PasswordTextFieldComponent(
      label: Str.of(context).passwordConfirmation,
      isRequired: true,
      onChanged: context.read<SignUpCubit>().passwordConfirmationChanged,
      onSubmitted: (_) => _onFormSubmitted(context),
      validator: (_) =>
          !isValid ? Str.of(context).invalidPasswordConfirmationMessage : null,
    );
  }
}

void _onFormSubmitted(BuildContext context) {
  final SignUpCubit cubit = context.read<SignUpCubit>();
  if (cubit.state.canSubmit) cubit.submit();
}
