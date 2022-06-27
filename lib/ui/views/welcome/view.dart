import 'package:flutter/material.dart';

import 'apps/view.dart';
import 'welcome_animation.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            WelcomeAnimation(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: AppSelector(),
            ),
          ],
        ),
      ),
    );
  }
}
