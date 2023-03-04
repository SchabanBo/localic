import 'package:flutter/material.dart';
import 'package:q_overlay/q_overlay.dart';

import 'auto_save_section.dart';
import 'translation_settings.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Center(
          child: Text('Settings', style: TextStyle(fontSize: 24)),
        ),
        const Divider(),
        const TranslationSection(),
        const AutoSaveSection(),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            child: const SizedBox(
              width: double.infinity,
              child: Center(child: Text('Save')),
            ),
            onPressed: () => QOverlay.dismissLast(),
          ),
        ),
      ],
    );
  }
}
