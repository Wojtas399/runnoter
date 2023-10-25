import 'package:flutter/material.dart';

class AppBarWithLogo extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWithLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: kToolbarHeight,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset('assets/logo.png'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
