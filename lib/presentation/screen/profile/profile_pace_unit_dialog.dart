import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/profile/pace_unit_cubit.dart';
import '../../../domain/entity/settings.dart';
import '../../../domain/repository/user_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/text/body_text_components.dart';
import '../../extension/context_extensions.dart';
import '../../formatter/pace_unit_formatter.dart';
import '../../service/navigator_service.dart';

class ProfilePaceUnitDialog extends StatelessWidget {
  const ProfilePaceUnitDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _CubitProvider(
      child: context.isMobileSize
          ? const _FullScreenDialog()
          : const _NormalDialog(),
    );
  }
}

class _CubitProvider extends StatelessWidget {
  final Widget child;

  const _CubitProvider({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => PaceUnitCubit(
        authService: context.read<AuthService>(),
        userRepository: context.read<UserRepository>(),
      )..initialize(),
      child: child,
    );
  }
}

class _NormalDialog extends StatelessWidget {
  const _NormalDialog();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return AlertDialog(
      title: Text(str.paceUnit),
      contentPadding: const EdgeInsets.symmetric(vertical: 24),
      content: const SizedBox(
        width: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(),
            SizedBox(height: 16),
            _OptionsToSelect(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => navigateBack(context: context),
          child: Text(str.close),
        ),
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
        title: Text(Str.of(context).paceUnit),
        leading: IconButton(
          onPressed: () => navigateBack(context: context),
          icon: const Icon(Icons.close),
        ),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(),
              SizedBox(height: 16),
              _OptionsToSelect(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: BodyLarge(Str.of(context).paceUnitSelect),
    );
  }
}

class _OptionsToSelect extends StatelessWidget {
  const _OptionsToSelect();

  @override
  Widget build(BuildContext context) {
    final PaceUnit? selectedDistanceUnit = context.select(
      (PaceUnitCubit cubit) => cubit.state,
    );

    return Column(
      children: PaceUnit.values
          .map(
            (PaceUnit paceUnit) => RadioListTile<PaceUnit>(
              title: Text(
                paceUnit.toUIFormat(),
              ),
              value: paceUnit,
              groupValue: selectedDistanceUnit,
              onChanged: (PaceUnit? paceUnit) {
                _onPaceUnitChanged(context, paceUnit);
              },
            ),
          )
          .toList(),
    );
  }

  void _onPaceUnitChanged(
    BuildContext context,
    PaceUnit? newPaceUnit,
  ) {
    if (newPaceUnit != null) {
      context.read<PaceUnitCubit>().updatePaceUnit(
            newPaceUnit: newPaceUnit,
          );
    }
  }
}
