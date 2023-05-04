import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../config/navigation/routes.dart';
import '../../../service/dialog_service.dart';
import '../../../service/navigator_service.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            _TopContent(),
            _BottomContent(),
          ],
        ),
      ),
    );
  }
}

class _TopContent extends StatelessWidget {
  const _TopContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _UserInfo(),
          SizedBox(height: 32),
          _Profile(),
          _Mileage(),
          _Blood(),
          _Competitions(),
        ],
      ),
    );
  }
}

class _BottomContent extends StatelessWidget {
  const _BottomContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _SignOut(),
        SizedBox(height: 8),
        _AppLogo(),
      ],
    );
  }
}

class _UserInfo extends StatelessWidget {
  const _UserInfo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _LoggedUserFullName(),
          SizedBox(height: 4),
          _LoggedUserEmail(),
        ],
      ),
    );
  }
}

class _Profile extends StatelessWidget {
  const _Profile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.account_circle),
      title: Text(
        Str.of(context).home_drawer_profile_label,
      ),
      onTap: () {
        _onPressed(context);
      },
    );
  }

  void _onPressed(BuildContext context) {
    navigateTo(
      context: context,
      route: const ProfileRoute(),
    );
  }
}

class _Mileage extends StatelessWidget {
  const _Mileage();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.insert_chart),
      title: Text(
        Str.of(context).home_drawer_mileage_label,
      ),
      onTap: () {},
    );
  }
}

class _Blood extends StatelessWidget {
  const _Blood();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.water_drop),
      title: Text(
        Str.of(context).home_drawer_blood_label,
      ),
      onTap: () {},
    );
  }
}

class _Competitions extends StatelessWidget {
  const _Competitions();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.emoji_events),
      title: Text(
        Str.of(context).home_drawer_competitions_label,
      ),
      onTap: () {},
    );
  }
}

class _SignOut extends StatelessWidget {
  const _SignOut();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        Str.of(context).home_drawer_sign_out_option,
      ),
      leading: const Icon(Icons.logout),
      onTap: () {
        _onPressed(context);
      },
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    final HomeBloc bloc = context.read<HomeBloc>();
    final bool confirmed = await askForConfirmation(
      context: context,
      title: Str.of(context).home_sign_out_confirmation_dialog_title,
      message: Str.of(context).home_sign_out_confirmation_dialog_message,
      confirmButtonLabel: Str.of(context).home_drawer_sign_out_option,
    );
    if (confirmed == true) {
      bloc.add(
        const HomeEventSignOut(),
      );
    }
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 48,
            child: Image.asset('assets/logo.png'),
          )
        ],
      ),
    );
  }
}

class _LoggedUserFullName extends StatelessWidget {
  const _LoggedUserFullName();

  @override
  Widget build(BuildContext context) {
    final String? name = context.select(
      (HomeBloc bloc) => bloc.state.loggedUserName,
    );
    final String? surname = context.select(
      (HomeBloc bloc) => bloc.state.loggedUserSurname,
    );

    return Text(
      '${name ?? ''} ${surname ?? ''}',
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}

class _LoggedUserEmail extends StatelessWidget {
  const _LoggedUserEmail();

  @override
  Widget build(BuildContext context) {
    final String? email = context.select(
      (HomeBloc bloc) => bloc.state.loggedUserEmail,
    );

    return Text(email ?? '');
  }
}
