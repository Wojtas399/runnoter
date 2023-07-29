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
import 'text/body_text_components.dart';
import 'text/title_text_components.dart';

class ReauthenticationBottomSheet extends StatelessWidget {
  const ReauthenticationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Column(
              children: [
                TitleLarge(Str.of(context).reauthenticationTitle),
                const SizedBox(height: 16),
                const _Form(),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            width: double.infinity,
            child: TextButton(
              onPressed: () => popRoute(result: false),
              child: Text(Str.of(context).cancel),
            ),
          ),
        ],
      ),
    );
  }
}

class ReauthenticationDialog extends StatelessWidget {
  const ReauthenticationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Str.of(context).reauthenticationTitle),
      content: const SizedBox(
        width: 400,
        child: _Form(),
      ),
      actions: [
        TextButton(
          onPressed: () => popRoute(result: false),
          child: Text(Str.of(context).cancel),
        )
      ],
    );
  }
}

class _Form extends StatelessWidget {
  const _Form();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    const Widget gap = SizedBox(height: 24);

    return GestureDetector(
      onTap: unfocusInputs,
      child: Container(
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
            const _TwitterAuthentication(),
            gap,
          ],
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
    } on NetworkException catch (exception) {
      closeLoadingDialog();
      if (exception.code == NetworkExceptionCode.requestFailed) {
        await showNoInternetConnectionMessage();
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
        BodyMedium(
          Str.of(context).reauthenticationOrUse,
          color: Theme.of(context).colorScheme.outline,
        ),
        const SizedBox(width: 16),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _GoogleAuthentication extends StatelessWidget {
  const _GoogleAuthentication();

  @override
  Widget build(BuildContext context) => _SocialAuthenticationButton(
        svgIconPath: 'assets/google_icon.svg',
        onPressed: _authenticateWithGoogle,
      );

  Future<void> _authenticateWithGoogle() async {
    try {
      await getIt<AuthService>().reauthenticate(
        authProvider: const AuthProviderGoogle(),
      );
      popRoute(result: true);
    } on AuthException catch (exception) {
      if (exception.code != AuthExceptionCode.socialAuthenticationCancelled) {
        rethrow;
      }
    } on NetworkException catch (exception) {
      if (exception.code == NetworkExceptionCode.requestFailed) {
        await showNoInternetConnectionMessage();
      } else {
        rethrow;
      }
    }
  }
}

class _TwitterAuthentication extends StatelessWidget {
  const _TwitterAuthentication();

  @override
  Widget build(BuildContext context) => _SocialAuthenticationButton(
        svgIconPath: 'assets/twitter_icon.svg',
        onPressed: _authenticateWithTwitter,
      );

  Future<void> _authenticateWithTwitter() async {
    try {
      await getIt<AuthService>().reauthenticate(
        authProvider: const AuthProviderTwitter(),
      );
      popRoute(result: true);
    } on AuthException catch (exception) {
      if (exception.code != AuthExceptionCode.socialAuthenticationCancelled) {
        rethrow;
      }
    } on NetworkException catch (exception) {
      if (exception.code == NetworkExceptionCode.requestFailed) {
        await showNoInternetConnectionMessage();
      } else {
        rethrow;
      }
    }
  }
}

class _SocialAuthenticationButton extends StatelessWidget {
  final String svgIconPath;
  final VoidCallback onPressed;

  const _SocialAuthenticationButton({
    required this.svgIconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: OutlinedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SvgPicture.asset(svgIconPath),
        ),
      ),
    );
  }
}
