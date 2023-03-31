import 'package:flutter/material.dart';

import '../../../component/value_with_label_and_icon_component.dart';

class ProfileSettingsSection extends StatelessWidget {
  const ProfileSettingsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const Widget gap = SizedBox(height: 8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _Header(),
        SizedBox(height: 16),
        _Theme(),
        gap,
        _Language(),
        gap,
        _DistanceUnit(),
        gap,
        _PaceUnit(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Ustawienia',
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}

class _Theme extends StatelessWidget {
  const _Theme();

  @override
  Widget build(BuildContext context) {
    return ValueWithLabelAndIconComponent(
      label: 'Motyw',
      iconData: Icons.brightness_6_outlined,
      value: 'Ciemny',
    );
  }
}

class _Language extends StatelessWidget {
  const _Language();

  @override
  Widget build(BuildContext context) {
    return ValueWithLabelAndIconComponent(
      label: 'Język',
      iconData: Icons.translate_outlined,
      value: 'Polski',
    );
  }
}

class _DistanceUnit extends StatelessWidget {
  const _DistanceUnit();

  @override
  Widget build(BuildContext context) {
    return ValueWithLabelAndIconComponent(
      label: 'Jednostka dystansu',
      iconData: Icons.route_outlined,
      value: 'km',
    );
  }
}

class _PaceUnit extends StatelessWidget {
  const _PaceUnit();

  @override
  Widget build(BuildContext context) {
    return ValueWithLabelAndIconComponent(
      label: 'Jednostka prędkości',
      iconData: Icons.speed_outlined,
      value: 'min/km',
    );
  }
}
