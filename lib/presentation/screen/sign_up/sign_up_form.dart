import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/sign_up/sign_up_bloc.dart';
import '../../../domain/entity/user.dart';
import '../../../domain/use_case/add_user_data_use_case.dart';
import '../../component/gap/gap_components.dart';
import '../../component/password_text_field_component.dart';
import '../../component/text_field_component.dart';
import '../../component/two_options_component.dart';

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
      (SignUpBloc bloc) => bloc.state.accountType,
    );

    return selectedAccountType == null
        ? const SizedBox()
        : TwoOptions<AccountType>(
            label: str.accountType,
            selectedValue: selectedAccountType,
            option1: OptionParams(label: str.runner, value: AccountType.runner),
            option2: OptionParams(label: str.coach, value: AccountType.coach),
            onChanged: (accountType) => _onChanged(context, accountType),
          );
  }

  void _onChanged(BuildContext context, AccountType accountType) {
    context.read<SignUpBloc>().add(
          SignUpEventAccountTypeChanged(accountType: accountType),
        );
  }
}

class _Gender extends StatelessWidget {
  const _Gender();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    final Gender? selectedGender = context.select(
      (SignUpBloc bloc) => bloc.state.gender,
    );

    return selectedGender == null
        ? const SizedBox()
        : TwoOptions<Gender>(
            label: str.gender,
            selectedValue: selectedGender,
            option1: OptionParams(label: str.male, value: Gender.male),
            option2: OptionParams(label: str.female, value: Gender.female),
            onChanged: (gender) => _onChanged(context, gender),
          );
  }

  void _onChanged(BuildContext context, Gender gender) {
    context.read<SignUpBloc>().add(
          SignUpEventGenderChanged(gender: gender),
        );
  }
}

class _Name extends StatelessWidget {
  const _Name();

  @override
  Widget build(BuildContext context) {
    final bool isValid = context.select(
      (SignUpBloc bloc) => bloc.state.isNameValid,
    );
    final str = Str.of(context);

    return TextFieldComponent(
      icon: Icons.person,
      label: str.name,
      isRequired: true,
      onChanged: (String? value) => _onChanged(value, context),
      validator: (_) => !isValid ? str.invalidNameOrSurnameMessage : null,
    );
  }

  void _onChanged(String? value, BuildContext context) {
    context.read<SignUpBloc>().add(
          SignUpEventNameChanged(name: value ?? ''),
        );
  }
}

class _Surname extends StatelessWidget {
  const _Surname();

  @override
  Widget build(BuildContext context) {
    final bool isValid = context.select(
      (SignUpBloc bloc) => bloc.state.isSurnameValid,
    );
    final str = Str.of(context);

    return TextFieldComponent(
      icon: Icons.person,
      label: str.surname,
      isRequired: true,
      onChanged: (String? value) => _onChanged(value, context),
      validator: (_) => !isValid ? str.invalidNameOrSurnameMessage : null,
    );
  }

  void _onChanged(String? value, BuildContext context) {
    context.read<SignUpBloc>().add(
          SignUpEventSurnameChanged(surname: value ?? ''),
        );
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    final bool isValid = context.select(
      (SignUpBloc bloc) => bloc.state.isEmailValid,
    );
    final str = Str.of(context);

    return TextFieldComponent(
      icon: Icons.email,
      label: str.email,
      isRequired: true,
      onChanged: (String? value) => _onChanged(value, context),
      validator: (_) => !isValid ? str.invalidEmailMessage : null,
    );
  }

  void _onChanged(String? value, BuildContext context) {
    context.read<SignUpBloc>().add(
          SignUpEventEmailChanged(email: value ?? ''),
        );
  }
}

class _Password extends StatelessWidget {
  const _Password();

  @override
  Widget build(BuildContext context) {
    final bool isValid = context.select(
      (SignUpBloc bloc) => bloc.state.isPasswordValid,
    );

    return PasswordTextFieldComponent(
      isRequired: true,
      onChanged: (String? value) => _onChanged(value, context),
      validator: (_) =>
          !isValid ? Str.of(context).invalidPasswordMessage : null,
    );
  }

  void _onChanged(String? value, BuildContext context) {
    context.read<SignUpBloc>().add(
          SignUpEventPasswordChanged(password: value ?? ''),
        );
  }
}

class _PasswordConfirmation extends StatelessWidget {
  const _PasswordConfirmation();

  @override
  Widget build(BuildContext context) {
    final bool isValid = context.select(
      (SignUpBloc bloc) => bloc.state.isPasswordConfirmationValid,
    );

    return PasswordTextFieldComponent(
      label: Str.of(context).passwordConfirmation,
      isRequired: true,
      onChanged: (String? value) => _onChanged(value, context),
      validator: (_) =>
          !isValid ? Str.of(context).invalidPasswordConfirmationMessage : null,
    );
  }

  void _onChanged(String? value, BuildContext context) {
    context.read<SignUpBloc>().add(
          SignUpEventPasswordConfirmationChanged(
            passwordConfirmation: value ?? '',
          ),
        );
  }
}
