import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:q_overlay/q_overlay.dart';

import '../../../../helpers/constants.dart';
import 'view.dart';

class SettingsIcon extends ConsumerWidget {
  const SettingsIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () => QPanel(
        child: const SettingsView(),
        alignment: Alignment.centerRight,
      ).show(),
      icon: const Icon(Icons.settings, color: AppColors.icon),
      tooltip: 'Settings',
    );
  }
}
