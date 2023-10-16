import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../../component/material_3_speed_dial_component.dart';
import '../../../config/navigation/router.dart';
import '../../../cubit/client/client_cubit.dart';
import '../../../service/navigator_service.dart';

class ClientMobileGeneralFAB extends StatelessWidget {
  final _buttonKey = GlobalKey();
  final RouteData currentRoute;

  ClientMobileGeneralFAB({super.key, required this.currentRoute});

  bool get _isSpeedDialRequired =>
      currentRoute.name == ClientCalendarRoute.name ||
      currentRoute.name == ClientStatsRoute.name;

  @override
  Widget build(BuildContext context) {
    return _isSpeedDialRequired
        ? Material3SpeedDial(
            icon: Icons.add,
            label: Text(
              _getLabel(Str.of(context), currentRoute),
            ),
            children: [
              SpeedDialChild(
                child: const Icon(Icons.emoji_events),
                label: Str.of(context).race,
                onTap: () => _manageEntityToAdd(
                  _EntityToAdd.race,
                  context.read<ClientCubit>().clientId,
                ),
              ),
              SpeedDialChild(
                child: const Icon(Icons.directions_run),
                label: Str.of(context).workout,
                onTap: () => _manageEntityToAdd(
                  _EntityToAdd.workout,
                  context.read<ClientCubit>().clientId,
                ),
              ),
            ],
          )
        : FloatingActionButton.extended(
            key: _buttonKey,
            onPressed: () => _onPressed(context, _buttonKey, currentRoute),
            icon: const Icon(Icons.add),
            label: Text(
              _getLabel(Str.of(context), currentRoute),
            ),
          );
  }
}

class ClientRailGeneralFAB extends StatelessWidget {
  final _buttonKey = GlobalKey();
  final RouteData currentRoute;

  ClientRailGeneralFAB({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      key: _buttonKey,
      onPressed: () => _onPressed(context, _buttonKey, currentRoute),
      child: const Icon(Icons.add),
    );
  }
}

class ClientDrawerGeneralFAB extends StatelessWidget {
  final _buttonKey = GlobalKey();
  final RouteData currentRoute;

  ClientDrawerGeneralFAB({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FloatingActionButton.extended(
        key: _buttonKey,
        onPressed: () => _onPressed(context, _buttonKey, currentRoute),
        icon: const Icon(Icons.add),
        label: Text(
          _getLabel(Str.of(context), currentRoute),
        ),
      ),
    );
  }
}

enum _EntityToAdd { workout, race, bloodTest }

Future<void> _manageEntityToAdd(
  _EntityToAdd entityToAdd,
  String clientId,
) async {
  switch (entityToAdd) {
    case _EntityToAdd.workout:
      navigateTo(
        WorkoutCreatorRoute(userId: clientId),
      );
      break;
    case _EntityToAdd.race:
      navigateTo(
        RaceCreatorRoute(userId: clientId),
      );
      break;
    case _EntityToAdd.bloodTest:
      navigateTo(
        BloodTestCreatorRoute(userId: clientId),
      );
      break;
  }
}

String _getLabel(Str str, RouteData currentRoute) {
  final String currentRouteName = currentRoute.name;
  if (currentRouteName == ClientBloodTestsRoute.name) {
    return str.addBloodTest;
  } else if (currentRouteName == ClientRacesRoute.name) {
    return str.addRace;
  }
  return str.add;
}

Future<void> _onPressed(
  BuildContext context,
  GlobalKey buttonKey,
  RouteData currentRoute,
) async {
  final String clientId = context.read<ClientCubit>().clientId;
  final _EntityToAdd? entityToAdd =
      await _askForEntityToAdd(context, buttonKey, currentRoute);
  if (entityToAdd != null) {
    await _manageEntityToAdd(entityToAdd, clientId);
  }
}

Future<_EntityToAdd?> _askForEntityToAdd(
  BuildContext context,
  GlobalKey buttonKey,
  RouteData currentRoute,
) async {
  if (currentRoute.name == ClientBloodTestsRoute.name) {
    return _EntityToAdd.bloodTest;
  } else if (currentRoute.name == ClientRacesRoute.name) {
    return _EntityToAdd.race;
  }
  final RenderBox? renderBox =
      buttonKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) return null;
  final Size size = renderBox.size;
  final Offset offset = renderBox.localToGlobal(Offset.zero);
  final str = Str.of(context);
  return await showMenu<_EntityToAdd?>(
    context: context,
    position: RelativeRect.fromLTRB(
      offset.dx,
      offset.dy + size.height,
      offset.dx + size.width,
      offset.dy + size.height,
    ),
    surfaceTintColor: Theme.of(context).canvasColor,
    items: [
      PopupMenuItem(
        value: _EntityToAdd.workout,
        child: SizedBox(
          width: size.width,
          child: Text(str.workout),
        ),
      ),
      PopupMenuItem(
        value: _EntityToAdd.race,
        child: Text(str.race),
      ),
    ],
  );
}
