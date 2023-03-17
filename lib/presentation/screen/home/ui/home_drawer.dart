import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _TopContent(),
          _BottomContent(),
        ],
      ),
    );
  }
}

class _TopContent extends StatelessWidget {
  const _TopContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 42),
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
        children: [
          Text(
            'Wojciech Piekielny',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          const Text('wojtekp@example.com'),
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
      title: const Text('Profil'),
      onTap: () {},
    );
  }
}

class _Mileage extends StatelessWidget {
  const _Mileage();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.insert_chart),
      title: const Text('Kilometraż'),
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
      title: const Text('Krew'),
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
      title: const Text('Krew'),
      onTap: () {},
    );
  }
}

class _SignOut extends StatelessWidget {
  const _SignOut();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Wyloguj'),
      leading: const Icon(Icons.logout),
      onTap: () {},
    );
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
