import 'package:flutter/material.dart';
import 'package:q_overlay/q_overlay.dart';

import '../../../../helpers/constants.dart';
import 'view.dart';

class LanguageIcon extends StatelessWidget {
  const LanguageIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Language Settings',
      onPressed: () async {
        await QPanel(
          name: 'SettingsScreen',
          child: const LanguageView(),
          alignment: Alignment.centerRight,
        ).show();
      },
      icon: const Icon(
        Icons.language,
        color: AppColors.icon,
      ),
    );
  }
}
