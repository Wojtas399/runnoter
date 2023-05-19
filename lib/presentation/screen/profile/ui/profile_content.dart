import 'package:flutter/material.dart';

import 'profile_settings_section.dart';
import 'profile_user_data_section.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                ProfileUserDataSection(),
                Divider(),
                SizedBox(height: 16),
                ProfileSettingsSection(),
                SizedBox(height: 160),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
