import 'package:flutter/material.dart';

import '../../component/body/medium_body_component.dart';
import '../../component/card_body_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/responsive_layout_component.dart';
import 'profile_settings_section.dart';
import 'profile_user_data_section.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: MediumBody(
        child: Paddings24(
          child: ResponsiveLayout(
            mobileBody: _MobileContent(),
            tabletBody: _DesktopContent(),
            desktopBody: _DesktopContent(),
          ),
        ),
      ),
    );
  }
}

class _MobileContent extends StatelessWidget {
  const _MobileContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ProfileUserDataSection(),
        Divider(height: 32),
        ProfileSettingsSection(),
      ],
    );
  }
}

class _DesktopContent extends StatelessWidget {
  const _DesktopContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CardBody(child: ProfileUserDataSection()),
        SizedBox(height: 16),
        CardBody(child: ProfileSettingsSection()),
      ],
    );
  }
}
