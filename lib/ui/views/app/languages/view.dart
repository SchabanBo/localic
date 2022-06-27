import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:q_overlay/q_overlay.dart';

import 'language_dialog.dart';
import 'view_model.dart';

class LanguageView extends ConsumerWidget {
  const LanguageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(languageVMProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Languages', style: TextStyle(fontSize: 20)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.add_box, color: Colors.green),
                onPressed: () => _addLanguage(vm),
              ),
            ],
          ),
          const Divider(),
          const Expanded(child: _LanguageList()),
          ElevatedButton(
            child: const SizedBox(
              width: double.infinity,
              child: Center(child: Text('Close')),
            ),
            onPressed: () => QOverlay.dismissName('SettingsScreen'),
          ),
        ],
      ),
    );
  }

  void _addLanguage(LanguageViewModel vm) async {
    QDialog(child: LanguageDialog(), width: 200).show<String>().then((value) {
      if (value != null && value.isNotEmpty) {
        vm.addLanguage(value);
      }
    });
  }
}

class _LanguageList extends ConsumerWidget {
  const _LanguageList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(languageVMProvider);
    return ListView(
      shrinkWrap: true,
      children: [
        for (final language in vm.languages)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(language, style: const TextStyle(fontSize: 18)),
                  const Spacer(),
                  InkWell(
                    child: const Icon(Icons.arrow_upward),
                    onTap: () => vm.moveLanguage(language, -1),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    child: const Icon(Icons.arrow_downward),
                    onTap: () => vm.moveLanguage(language, 1),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    child: const Icon(Icons.edit, color: Colors.amber),
                    onTap: () => _editLanguage(vm, language),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    child: const Icon(Icons.delete, color: Colors.red),
                    onTap: () => _removeLanguage(context, vm, language),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _editLanguage(LanguageViewModel vm, String language) {
    QDialog(child: LanguageDialog(value: language), width: 200)
        .show<String>()
        .then((value) {
      if (value != null && value.isNotEmpty) {
        vm.updateLanguage(language, value);
      }
    });
  }

  void _removeLanguage(
      BuildContext context, LanguageViewModel vm, String language) {
    QDialog(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Are you sure you want to delete this language?'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          child: const Text('Yes'),
                          onPressed: () =>
                              QOverlay.dismissLast<bool>(result: true),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextButton(
                            onPressed: QOverlay.dismissLast,
                            child: const Text('No')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            width: 200)
        .show<bool>()
        .then((value) {
      if (value ?? false) {
        vm.removeLanguage(language);
      }
    });
  }
}
