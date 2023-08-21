import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/additional_model/calendar_date_range_data.dart';
import '../../../domain/cubit/calendar_date_range_data_cubit.dart';
import '../body/big_body_component.dart';
import '../card_body_component.dart';
import '../gap/gap_components.dart';
import '../padding/paddings_24.dart';
import '../responsive_layout_component.dart';
import 'bloc/calendar_component_bloc.dart';
import 'calendar_component__month.dart';
import 'calendar_component_date.dart';
import 'calendar_component_week.dart';

class CalendarComponent extends StatelessWidget {
  final DateRangeType? dateRangeType;
  final Function(DateTime startDate, DateTime endDate) onDateRangeChanged;

  const CalendarComponent({
    super.key,
    this.dateRangeType,
    required this.onDateRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarComponentBloc()
        ..add(CalendarComponentEventInitialize(
          dateRangeType: dateRangeType ?? DateRangeType.week,
        )),
      child: _BlocListener(
        onDateRangeChanged: onDateRangeChanged,
        child: const _Content(),
      ),
    );
  }
}

class _BlocListener extends StatelessWidget {
  final Function(DateTime startDate, DateTime endDate) onDateRangeChanged;
  final Widget child;

  const _BlocListener({required this.onDateRangeChanged, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CalendarComponentBloc, CalendarComponentState>(
      listenWhen: (previousState, currentState) =>
          previousState.weeks == null ||
          previousState.dateRange != currentState.dateRange,
      listener: (_, CalendarComponentState state) {
        _emitNewDateRange(state);
      },
      child: child,
    );
  }

  void _emitNewDateRange(CalendarComponentState state) {
    if (state.weeks != null) {
      final DateTime startDate = state.weeks!.first.days.first.date;
      final DateTime endDate = state.weeks!.last.days.last.date;
      onDateRangeChanged(startDate, endDate);
    }
  }
}

class _Content extends StatefulWidget {
  const _Content();

  @override
  State<StatefulWidget> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  StreamSubscription<CalendarDateRangeData>? _dateRangeDataListener;

  @override
  void initState() {
    _dateRangeDataListener ??=
        context.read<CalendarDateRangeDataCubit>().stream.listen(
      (dateRangeData) {
        context.read<CalendarComponentBloc>().add(
              CalendarComponentEventDateRangeDataUpdated(data: dateRangeData),
            );
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _dateRangeDataListener?.cancel();
    _dateRangeDataListener = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: BigBody(
        child: Paddings24(
          child: ResponsiveLayout(
            mobileBody: _Calendar(),
            desktopBody: CardBody(
              child: _Calendar(),
            ),
          ),
        ),
      ),
    );
  }
}

class _Calendar extends StatelessWidget {
  const _Calendar();

  @override
  Widget build(BuildContext context) {
    final DateRange? dateRange = context.select(
      (CalendarComponentBloc bloc) => bloc.state.dateRange,
    );

    return Column(
      children: [
        const CalendarComponentDate(),
        const Gap8(),
        switch (dateRange) {
          DateRangeWeek() => const CalendarComponentWeek(),
          DateRangeMonth() => const CalendarComponentMonth(),
          null => const CircularProgressIndicator(),
        }
      ],
    );
  }
}
