import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/local_data/json/data.dart';
import '../../../ui/views/app/editor/view_model.dart';
import '../../../ui/views/app/view_model.dart';
import '../../../ui/widgets/error_notification.dart';
import '../storage_service.dart';

class JsonFileImporter {
  final WidgetRef ref;

  JsonFileImporter(this.ref);

  Future<void> import(String file, String lan) async {
    ref.read(workingProvider.notifier).state = 'Importing locales...';
    if (!kIsWeb) {
      final data = await ref.read(storageServiceProvider).readFile(file);
      if (data == null) {
        showNotification('File not found', 'File not found');
        return;
      }
      file = data;
    }

    importData(file, lan);
    ref.read(workingProvider.notifier).state = '';
  }

  Future<void> importData(String data, String lan) async {
    final locales = ref.read(editorVMProvider).locales;
    final node = JsonNode(lan);
    node.fromMap(jsonDecode(data) as Map<String, dynamic>);
    locales.languages.add(lan);
    for (var child in node.children) {
      if (child is JsonNode) {
        locales.addLocalNode(lan, child);
      } else if (child is JsonItem) {
        locales.addLocalItem(lan, child);
      }
    }
    ref.read(editorVMProvider).refresh();
  }
}
