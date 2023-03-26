import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/repository/user_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../component/bloc_with_status_listener_component.dart';
import '../../../service/dialog_service.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import 'profile_content.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _BlocProvider(
      child: _BlocListener(
        child: ProfileContent(),
      ),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final Widget child;

  const _BlocProvider({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ProfileBloc(
        authService: context.read<AuthService>(),
        userRepository: context.read<UserRepository>(),
      )..add(
          const ProfileEventInitialize(),
        ),
      child: child,
    );
  }
}

class _BlocListener extends StatelessWidget {
  final Widget child;

  const _BlocListener({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocWithStatusListener<ProfileBloc, ProfileState, ProfileInfo,
        ProfileError>(
      child: child,
      onInfo: (ProfileInfo info) {
        _manageInfo(context, info);
      },
      onError: (ProfileError error) {
        _manageError(context, error);
      },
    );
  }

  void _manageInfo(BuildContext context, ProfileInfo info) {
    switch (info) {
      case ProfileInfo.savedData:
        showSnackbarMessage(
          context: context,
          message: 'Pomyślnie zapisano zmiany',
        );
        break;
    }
  }

  void _manageError(BuildContext context, ProfileError error) {
    switch (error) {
      case ProfileError.emailAlreadyInUse:
        showMessageDialog(
          context: context,
          title: 'Zajęty adres email',
          message:
              'Niestety, nowo podany adres email jest już zajęty przez innego użytkownika...',
        );
        break;
      case ProfileError.wrongPassword:
        showMessageDialog(
          context: context,
          title: 'Błędne hasło',
          message: 'Podane hasło jest błędne...',
        );
        break;
    }
  }
}
