import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:q_overlay/q_overlay.dart';

import '../../../../../global/services/settings_service.dart';
import '../../../../../global/services/translators/google_translator_service.dart';
import '../../../../../helpers/constants.dart';
import '../../../../../models/local_data/local.dart';
import '../../../../widgets/error_notification.dart';
import '../../view_model.dart';
import '../view_model.dart';
import 'view.dart';
import 'view_model.dart';

class OptionsWidget extends ConsumerWidget {
  final LocalItemVM vm;
  const OptionsWidget({required this.vm, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vmValue = ref.watch(vm);
    return Row(
      children: [
        InkWell(
          onTap: () => copyPath(ref),
          child: const Tooltip(
              message: 'Copy Path',
              child: Icon(
                Icons.copy,
                color: AppColors.icon,
              )),
        ),
        const SizedBox(width: 5),
        InkWell(
          onTap: () => translate(ref),
          child: const Tooltip(
              message: 'Translate',
              child: Icon(
                Icons.translate,
                color: AppColors.icon,
              )),
        ),
        const SizedBox(width: 5),
        InkWell(
          onTap: () => duplicate(ref),
          child: const Tooltip(
            message: 'Duplicate',
            child: Icon(Icons.copy_all, color: AppColors.icon),
          ),
        ),
        const SizedBox(width: 5),
        InkWell(
          child: const Tooltip(
              message: 'Delete',
              child: Icon(
                Icons.delete_outline,
                color: AppColors.icon,
              )),
          onTap: () => _deleteDialog(vmValue).show(),
        ),
      ],
    );
  }

  QDialog _deleteDialog(LocalItemViewModel vmValue) {
    return QDialog(
      child: SizedBox(
        width: 250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure you want to delete ${vmValue.item.name}?'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: QOverlay.dismissLast,
                    child: const Text('No'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      vmValue.editorVM.removeItem(vmValue.indexMap);
                      QOverlay.dismissLast();
                    },
                    child: const Text('Yes'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void translate(WidgetRef ref) async {
    ref.read(workingProvider.notifier).state = 'Translating...';
    final languages = ref.read(editorVMProvider).locales.languages;
    final lan = await QDialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Translate from :',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            ...languages
                .map((e) => TextButton(
                      onPressed: () => QOverlay.dismissLast(result: e),
                      child: Text(e),
                    ))
                .toList()
          ],
        ),
      ),
    ).show<String>();
    if (lan == null) {
      ref.read(workingProvider.notifier).state = '';
      return;
    }
    final settings = ref.read(settingsProvider).settings.translation;
    if (settings.googleApi.isEmpty) {
      showNotification(
        'api key is missing',
        'Google api key is empty, please set it first in the settings',
      );
      ref.read(workingProvider.notifier).state = '';
      return;
    }
    final service = GoogleTranslatorService(settings.googleApi);
    await service.translate(ref.read(vm).item, lan);
    ref.read(editorVMProvider).refresh();
    ref.read(workingProvider.notifier).state = '';
  }

  void copyPath(WidgetRef ref) {
    final indexMap = ref.read(vm).indexMap;
    var result = '';
    LocalNode node = ref.read(editorVMProvider).locales;

    for (var i = 1; i < indexMap.length - 1; i++) {
      node = node.children
          .whereType<LocalNode>()
          .firstWhere((e) => e.hashCode == indexMap[i]);
      result += '${node.name}_';
    }
    final item = node.children.firstWhere((e) => e.hashCode == indexMap.last);
    result += item.name;
    Clipboard.setData(ClipboardData(text: result));
  }

  void duplicate(WidgetRef ref) {
    final editor = ref.read(editorVMProvider);
    final viewModel = ref.read(vm);
    final item = viewModel.item;
    final newItem = item.copyWith(name: '${item.name}_copy');
    newItem.values.addAll(Map.from(item.values));
    editor.addItem(
      List.from(viewModel.indexMap)..removeLast(),
      newItem,
      itemHashCode: item.hashCode,
    );
  }
}
