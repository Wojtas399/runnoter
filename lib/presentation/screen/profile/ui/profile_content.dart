import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../component/big_button_component.dart';
import '../../../service/navigator_service.dart';
import 'profile_settings_section.dart';
import 'profile_user_data_section.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Str.of(context).profileScreenTitle,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: const [
                    ProfileUserDataSection(),
                    Divider(),
                    SizedBox(height: 16),
                    ProfileSettingsSection(),
                    SizedBox(height: 160),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: BigButton(
                label: Str.of(context).back,
                onPressed: () {
                  navigateBack(context: context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
