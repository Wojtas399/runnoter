import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.profile_screen_title,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Profile screen'),
      ),
    );
  }
}
