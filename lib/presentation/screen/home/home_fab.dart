import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../../dependency_injection.dart';
import '../../../domain/additional_model/coaching_request.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/material_3_speed_dial_component.dart';
import '../../config/navigation/router.dart';
import '../../dialog/health_measurement_creator/health_measurement_creator_dialog.dart';
import '../../dialog/persons_search/persons_search_dialog.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';

class HomeMobileFAB extends StatelessWidget {
  final _buttonKey = GlobalKey();
  final RouteData currentRoute;

  HomeMobileFAB({super.key, required this.currentRoute});

  bool get _isSpeedDialRequired =>
      currentRoute.name == CalendarRoute.name ||
      currentRoute.name == MileageRoute.name;

  @override
  Widget build(BuildContext context) {
    return _isSpeedDialRequired
        ? Material3SpeedDial(
            icon: Icons.add,
            label: Text(_getLabel(Str.of(context), currentRoute)),
            children: [
              SpeedDialChild(
                child: const Icon(Icons.emoji_events),
                label: Str.of(context).race,
                onTap: () => _manageEntityToAdd(_EntityToAdd.race),
              ),
              SpeedDialChild(
                child: const Icon(Icons.directions_run),
                label: Str.of(context).workout,
                onTap: () => _manageEntityToAdd(_EntityToAdd.workout),
              ),
              if (currentRoute.name == CalendarRoute.name)
                SpeedDialChild(
                  child: const Icon(Icons.health_and_safety),
                  label: Str.of(context).healthMeasurement,
                  onTap: () => _manageEntityToAdd(
                    _EntityToAdd.healthMeasurement,
                  ),
                ),
            ],
          )
        : FloatingActionButton.extended(
            key: _buttonKey,
            onPressed: () => _onPressed(context, _buttonKey, currentRoute),
            icon: Icon(
              currentRoute.name == ClientsRoute.name ? Icons.search : Icons.add,
            ),
            label: Text(_getLabel(Str.of(context), currentRoute)),
          );
  }
}

class HomeRailFAB extends StatelessWidget {
  final _buttonKey = GlobalKey();
  final RouteData currentRoute;

  HomeRailFAB({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      key: _buttonKey,
      onPressed: () => _onPressed(context, _buttonKey, currentRoute),
      child: Icon(
        currentRoute.name == ClientsRoute.name ? Icons.search : Icons.add,
      ),
    );
  }
}

class HomeDrawerFAB extends StatelessWidget {
  final _buttonKey = GlobalKey();
  final RouteData currentRoute;

  HomeDrawerFAB({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      key: _buttonKey,
      onPressed: () => _onPressed(context, _buttonKey, currentRoute),
      icon: Icon(
        currentRoute.name == ClientsRoute.name ? Icons.search : Icons.add,
      ),
      label: Text(_getLabel(Str.of(context), currentRoute)),
    );
  }
}

enum _EntityToAdd { healthMeasurement, workout, race, bloodTest, client }

String _getLabel(Str str, RouteData currentRoute) {
  final String currentRouteName = currentRoute.name;
  if (currentRouteName == HealthRoute.name) {
    return str.addHealthMeasurement;
  } else if (currentRouteName == BloodTestsRoute.name) {
    return str.addBloodTest;
  } else if (currentRouteName == RacesRoute.name) {
    return str.addRace;
  } else if (currentRouteName == ClientsRoute.name) {
    return str.clientsSearchUsers;
  }
  return str.add;
}

Future<void> _onPressed(
  BuildContext context,
  GlobalKey buttonKey,
  RouteData currentRoute,
) async {
  final _EntityToAdd? entityToAdd =
      await _askForEntityToAdd(context, buttonKey, currentRoute);
  if (entityToAdd != null) {
    await _manageEntityToAdd(entityToAdd);
  }
}

Future<void> _manageEntityToAdd(_EntityToAdd entityToAdd) async {
  final String? loggedUserId = await getIt<AuthService>().loggedUserId$.first;
  switch (entityToAdd) {
    case _EntityToAdd.healthMeasurement:
      await showDialogDependingOnScreenSize(
        const HealthMeasurementCreatorDialog(),
      );
      break;
    case _EntityToAdd.workout:
      navigateTo(
        WorkoutCreatorRoute(userId: loggedUserId),
      );
      break;
    case _EntityToAdd.race:
      navigateTo(
        RaceCreatorRoute(userId: loggedUserId),
      );
      break;
    case _EntityToAdd.bloodTest:
      navigateTo(
        BloodTestCreatorRoute(userId: loggedUserId),
      );
      break;
    case _EntityToAdd.client:
      await showDialogDependingOnScreenSize(
        const PersonsSearchDialog(
          requestDirection: CoachingRequestDirection.coachToClient,
        ),
      );
      break;
  }
}

Future<_EntityToAdd?> _askForEntityToAdd(
  BuildContext context,
  GlobalKey buttonKey,
  RouteData currentRoute,
) async {
  if (currentRoute.name == HealthRoute.name) {
    return _EntityToAdd.healthMeasurement;
  } else if (currentRoute.name == BloodTestsRoute.name) {
    return _EntityToAdd.bloodTest;
  } else if (currentRoute.name == RacesRoute.name) {
    return _EntityToAdd.race;
  } else if (currentRoute.name == ClientsRoute.name) {
    return _EntityToAdd.client;
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
      if (currentRoute.name == CalendarRoute.name)
        PopupMenuItem(
          value: _EntityToAdd.healthMeasurement,
          child: Text(str.healthMeasurement),
        ),
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
