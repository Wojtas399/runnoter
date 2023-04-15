import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../component/big_button_component.dart';
import '../../../formatter/date_formatter.dart';
import '../bloc/day_preview_bloc.dart';

class DayPreviewContent extends StatelessWidget {
  const DayPreviewContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.day_preview_screen_title,
        ),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: _NoWorkoutContent(),
        ),
      ),
    );
  }
}

class _NoWorkoutContent extends StatelessWidget {
  const _NoWorkoutContent();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        _NoWorkoutInfo(),
        _Date(),
      ],
    );
  }
}

class _Date extends StatelessWidget {
  const _Date();

  @override
  Widget build(BuildContext context) {
    final DateTime? date = context.select(
      (DayPreviewBloc bloc) => bloc.state.date,
    );

    return Text(
      date?.toUIFormat(context) ?? '',
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}

class _NoWorkoutInfo extends StatelessWidget {
  const _NoWorkoutInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.day_preview_screen_no_workout_title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.day_preview_screen_no_workout_message,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        BigButton(
          label: AppLocalizations.of(context)!
              .day_preview_screen_add_workout_button_label,
          onPressed: () {},
        ),
      ],
    );
  }
}
