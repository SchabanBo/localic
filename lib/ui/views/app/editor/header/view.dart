import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:q_overlay/q_overlay.dart';

import '../../../../../global/services/settings_service.dart';
import '../../../../../global/services/translators/google_translator_service.dart';
import '../../../../../helpers/constants.dart';
import '../../../../../models/local_data/local.dart';
import '../../../../widgets/error_notification.dart';
import '../../view_model.dart';
import '../local_node/add_item.dart';
import '../view_model.dart';

const TextStyle _headerStyle = TextStyle(fontSize: 20);

class EditorHeaderWidget extends ConsumerWidget {
  const EditorHeaderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languages = ref.watch(editorVMProvider).locales.languages;
    return Container(
      padding: const EdgeInsets.only(bottom: 4),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.background,
            AppColors.border,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          const Expanded(child: Text('Keys', style: _headerStyle)),
          ...languages.map((l) =>
              Expanded(child: Center(child: Text(l, style: _headerStyle)))),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => translate(ref),
                  child: const Tooltip(
                    message: 'Translate',
                    child: Icon(Icons.translate, color: AppColors.icon),
                  ),
                ),
                const SizedBox(width: 5),
                const AddLocalNode(indexMap: [0]),
                const SizedBox(width: 5),
                const AddLocalItem(indexMap: [0]),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  void translate(WidgetRef ref) async {
    final workingMessage = ref.read(workingProvider.notifier);
    workingMessage.state = 'Translating...';
    final languages = ref.read(editorVMProvider).locales.languages;
    final lan = await QDialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'This will try to all the empty fields',
              style: _headerStyle,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Translate from :'),
                ...languages.map((e) => TextButton(
                      onPressed: () => QOverlay.dismissLast(result: e),
                      child: Text(e),
                    ))
              ],
            ),
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
      workingMessage.state = '';
      return;
    }
    final service = GoogleTranslatorService(settings.googleApi);
    final records = ref.watch(localesRecordsProvider);
    for (var record in records) {
      await _translateItem(service, record, lan);
    }
    ref.read(editorVMProvider).refresh();
    workingMessage.state = '';
  }

  Future<void> _translateItem(
    GoogleTranslatorService service,
    LocalBase item,
    String lan,
  ) async {
    if (item is LocalItem) {
      item = await service.translate(item, lan);
      return;
    }
    if (item is LocalNode) {
      for (var record in item.children) {
        await _translateItem(service, record, lan);
      }
    }
  }
}
