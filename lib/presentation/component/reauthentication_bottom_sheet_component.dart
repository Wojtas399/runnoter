import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';

import '../../dependency_injection.dart';
import '../../domain/additional_model/custom_exception.dart';
import '../../domain/entity/auth_provider.dart';
import '../../domain/service/auth_service.dart';
import '../service/dialog_service.dart';
import '../service/navigator_service.dart';
import '../service/utils.dart';
import 'password_text_field_component.dart';

class ReauthenticationBottomSheet extends StatelessWidget {
  const ReauthenticationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    const Widget gap = SizedBox(height: 24);

    return SafeArea(
      child: GestureDetector(
        onTap: unfocusInputs,
        child: Container(
          padding: const EdgeInsets.all(24),
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(str.reauthenticationMessage),
              gap,
              const _PasswordAuthentication(),
              gap,
              const _Separator(),
              gap,
              const _GoogleAuthentication(),
              gap,
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => popRoute(result: false),
                  child: Text(str.cancel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordAuthentication extends StatefulWidget {
  const _PasswordAuthentication();

  @override
  State<StatefulWidget> createState() => _PasswordAuthenticationState();
}

class _PasswordAuthenticationState extends State<_PasswordAuthentication> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isSubmitButtonDisabled = true;

  @override
  void initState() {
    _passwordController.addListener(_onPasswordChanged);
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.removeListener(_onPasswordChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PasswordTextFieldComponent(controller: _passwordController),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 40,
          child: FilledButton(
            onPressed: _isSubmitButtonDisabled ? null : _authenticate,
            child: Text(Str.of(context).reauthenticationAuthenticate),
          ),
        ),
      ],
    );
  }

  void _onPasswordChanged() {
    setState(() {
      _isSubmitButtonDisabled = _passwordController.text.isEmpty;
    });
  }

  Future<void> _authenticate() async {
    try {
      showLoadingDialog();
      await getIt<AuthService>().reauthenticate(
        authProvider: AuthProviderPassword(password: _passwordController.text),
      );
      closeLoadingDialog();
      popRoute(result: true);
    } on AuthException catch (exception) {
      closeLoadingDialog();
      if (exception.code == AuthExceptionCode.wrongPassword) {
        showMessageDialog(
          title: Str.of(context).reauthenticationWrongPasswordDialogTitle,
          message: Str.of(context).reauthenticationWrongPasswordDialogMessage,
        );
      }
    }
  }
}

class _Separator extends StatelessWidget {
  const _Separator();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        const SizedBox(width: 16),
        Text(Str.of(context).reauthenticationOrUse),
        const SizedBox(width: 16),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _GoogleAuthentication extends StatelessWidget {
  const _GoogleAuthentication();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: OutlinedButton(
        onPressed: _authenticateWithGoogle,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SvgPicture.asset('assets/google_icon.svg'),
        ),
      ),
    );
  }

  Future<void> _authenticateWithGoogle() async {
    try {
      showLoadingDialog();
      await getIt<AuthService>().reauthenticate(
        authProvider: const AuthProviderGoogle(),
      );
      closeLoadingDialog();
      popRoute(result: true);
    } catch (_) {}
  }
}
