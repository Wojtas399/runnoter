import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Material3SpeedDial extends SpeedDial {
  const Material3SpeedDial({
    super.key,
    super.label,
    super.icon,
    super.children,
  }) : super(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          spacing: 16,
          childMargin: EdgeInsets.zero,
          childPadding: const EdgeInsets.all(8.0),
        );
}
