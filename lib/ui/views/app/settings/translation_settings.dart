import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../global/services/settings_service.dart';

class TranslationSection extends HookConsumerWidget {
  const TranslationSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final translation = ref.read(settingsProvider).settings.translation;
    controller.text = translation.googleApi;
    return ExpansionTile(
      title: const Text('Translators settings'),
      children: [
        const Text('Google Api Key', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            obscureText: true,
            onChanged: (s) => translation.googleApi = s,
          ),
        )
      ],
    );
  }
}
