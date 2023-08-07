import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/profile/identities/profile_identities_bloc.dart';
import '../../component/body/medium_body_component.dart';
import '../../component/card_body_component.dart';
import '../../component/gap_components.dart';
import '../../component/responsive_layout_component.dart';
import 'profile_settings_section.dart';
import 'profile_user_data_section.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => _onRefresh(context),
      child: const SingleChildScrollView(
        child: MediumBody(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
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

  void _onRefresh(BuildContext context) {
    context.read<ProfileIdentitiesBloc>().add(
          const ProfileIdentitiesEventReloadLoggedUser(),
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
        Gap16(),
        CardBody(child: ProfileSettingsSection()),
      ],
    );
  }
}
