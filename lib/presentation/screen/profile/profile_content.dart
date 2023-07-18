import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../component/card_body_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/responsive_layout_component.dart';
import '../../config/body_sizes.dart';
import 'profile_settings_section.dart';
import 'profile_user_data_section.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: GetIt.I.get<BodySizes>().mediumBodyWidth,
          ),
          child: const Paddings24(
            child: ResponsiveLayout(
              mobileBody: _MobileContent(),
              tabletBody: _DesktopContent(),
              desktopBody: _DesktopContent(),
            ),
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
