import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../component/password_text_field_component.dart';
import '../../../model/bloc_status.dart';
import '../../../service/navigator_service.dart';
import '../../../service/utils.dart';
import '../bloc/profile_identities_bloc.dart';
import '../bloc/profile_identities_event.dart';
import '../bloc/profile_identities_state.dart';

class ProfileDeleteAccountDialog extends StatefulWidget {
  const ProfileDeleteAccountDialog({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<ProfileDeleteAccountDialog> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isSaveButtonDisabled = true;

  @override
  void initState() {
    _passwordController.addListener(_updateDeleteButtonDisableStatus);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileIdentitiesBloc, ProfileIdentitiesState>(
      listener: (BuildContext context, ProfileIdentitiesState state) {
        final BlocStatus blocStatus = state.status;
        if (blocStatus is BlocStatusComplete &&
            blocStatus.info == ProfileInfo.accountDeleted) {
          navigateBack(context: context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!
                .profile_screen_delete_account_dialog_title,
          ),
          leading: IconButton(
            onPressed: () {
              navigateBack(context: context);
            },
            icon: const Icon(Icons.close),
          ),
          actions: [
            TextButton(
              onPressed: _isSaveButtonDisabled
                  ? null
                  : () {
                      _onSaveButtonPressed(context);
                    },
              child: Text(
                AppLocalizations.of(context)!.delete,
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              unfocusInputs();
            },
            child: Container(
              padding: const EdgeInsets.all(24),
              color: Colors.transparent,
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .profile_screen_delete_account_dialog_message,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  PasswordTextFieldComponent(
                    label: AppLocalizations.of(context)!.password,
                    controller: _passwordController,
                    isRequired: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateDeleteButtonDisableStatus() {
    setState(() {
      _isSaveButtonDisabled = _passwordController.text.isEmpty;
    });
  }

  void _onSaveButtonPressed(BuildContext context) {
    context.read<ProfileIdentitiesBloc>().add(
          ProfileIdentitiesEventDeleteAccount(
            password: _passwordController.text,
          ),
        );
  }
}
