import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../../global/routers/app_routes.dart';
import '../../../global/services/exporters/export_service.dart';
import '../../../global/services/settings_service.dart';
import '../../../global/services/storage_service.dart';
import '../../../models/settings/app_file.dart';
import '../../../models/settings/auto_save.dart';
import '../../widgets/error_notification.dart';
import 'editor/view_model.dart';

class AppViewModel extends ChangeNotifier {
  final AppLocalFile app;
  final Ref ref;

  AppViewModel({required this.ref, required this.app}) {
    _runAutoSave();
  }

  Future<void> saveData() async {
    ref.read(workingProvider.notifier).state = 'Saving data...';
    final locales = ref.read(editorVMProvider).locales;
    await ref
        .read(storageServiceProvider)
        .saveLocals(app, locales.toData().toJson());
    ref.read(workingProvider.notifier).state = '';
  }

  void export({String? path, ExportAs? exportAs}) {
    ref.read(workingProvider.notifier).state = 'Exporting...';
    path = path ?? app.exportPath;
    final data = ref.read(editorVMProvider).locales.toData();
    final storage = ref.read(storageServiceProvider);
    final service = ExportService(data: data, storage: storage);
    if (exportAs == null) {
      final settings = ref.read(settingsProvider).settings;
      exportAs = settings.autoSave.exportAs;
    }
    switch (exportAs) {
      case ExportAs.getX:
        service.exportGetX(path);
        break;
      default:
        service.exportEasyLocalization(path);
    }
    ref.read(workingProvider.notifier).state = '';
  }

  void _runAutoSave() {
    final settings = ref.watch(settingsProvider).settings;

    if (!settings.autoSave.enabled) {
      _timer?.cancel();
      _timer = null;
      return;
    }
    final interval = settings.autoSave.interval;
    _timer = Timer.periodic(Duration(seconds: interval), (t) {
      saveData();
      export();
    });
  }
}

Timer? _timer;
final appVMProvider = Provider.autoDispose<AppViewModel>((ref) {
  final settings = ref.read(settingsProvider).settings;
  final appName = QR.params['name'].toString();
  if (!settings.apps.any((app) => app.name == appName)) {
    showNotification('Error', 'App not found');
    QR.to(AppRoutes.welcome);
  }
  ref.onDispose(() {
    _timer?.cancel();
    _timer = null;
  });
  return AppViewModel(
    ref: ref,
    app: settings.apps.firstWhere((app) => app.name == appName),
  );
});

final workingProvider = StateProvider.autoDispose<String>((ref) => '');

final filterProvider = StateProvider.autoDispose<String>((ref) => '');
