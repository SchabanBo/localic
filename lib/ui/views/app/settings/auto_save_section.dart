import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../global/services/settings_service.dart';
import '../../../../models/settings/auto_save.dart';
import '../../../widgets/widget_switcher.dart';

final _autoSaveProvider = StateProvider.autoDispose<AutoSave>((ref) {
  ref.onDispose(() {
    ref
        .read(settingsProvider)
        .saveSettings((s) => s.copyWith(autoSave: ref.controller.state));
  });
  return ref.watch(settingsProvider).settings.autoSave;
});

class AutoSaveSection extends ConsumerWidget {
  const AutoSaveSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoSave = ref.watch(_autoSaveProvider);

    return ExpansionTile(
      title: const Text('Auto Save settings'),
      children: [
        Column(
          children: [
            SwitchListTile(
              title: const Text('Auto Save'),
              value: autoSave.enabled,
              onChanged: (value) {
                ref.read(_autoSaveProvider.notifier).update((state) {
                  return state.copyWith(enabled: value);
                });
              },
            ),
            WidgetSwitcher(
              child: autoSave.enabled
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: autoSave.interval.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                            label: Text('Interval (Sec)')),
                        onChanged: (s) {
                          ref.read(_autoSaveProvider.notifier).update((state) {
                            return state.copyWith(interval: int.parse(s));
                          });
                        },
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Export with save'),
              value: autoSave.export,
              onChanged: (value) {
                ref.read(_autoSaveProvider.notifier).update((state) {
                  return state.copyWith(export: value);
                });
              },
            ),
            WidgetSwitcher(
              child: autoSave.export
                  ? const _SettingExportAsWidget()
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ],
    );
  }
}

class _SettingExportAsWidget extends ConsumerWidget {
  const _SettingExportAsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoSave = ref.watch(_autoSaveProvider);

    return Column(children: [
      for (final e in ExportAs.values)
        RadioListTile<ExportAs>(
          title: Text(e.name),
          value: e,
          groupValue: autoSave.exportAs,
          onChanged: (v) {
            ref.read(_autoSaveProvider.notifier).update((state) {
              return state.copyWith(exportAs: v!);
            });
          },
        )
    ]);
  }
}
