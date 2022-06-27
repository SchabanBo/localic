import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/settings/models.dart';
import '../../ui/views/app/view_model.dart';
import 'storage_service.dart';

final settingsProvider =
    ChangeNotifierProvider<SettingsService>((ref) => SettingsService(ref));

class SettingsService extends ChangeNotifier {
  Settings? _settings;
  bool get loaded => _settings != null;
  Settings get settings => _settings!;
  final Ref ref;

  SettingsService(this.ref);

  Future load(WidgetRef ref) async {
    final storageService = ref.read(storageServiceProvider);
    var settings = await storageService.loadSettings();
    if (settings == null) {
      final data = await rootBundle.loadString('assets/example/localic.json');
      const app = AppLocalFile(
        name: 'example',
        path: 'example_data/data.json',
        exportPath: 'example_data/',
      );
      ref.read(storageServiceProvider).saveLocals(app, data);
      settings = Settings.defaults();
      settings.apps.add(app);
    }
    _settings = settings;
    notifyListeners();
  }

  void saveSettings(Settings Function(Settings) settings) {
    ref.read(workingProvider.notifier).state = 'Saving settings...';
    final newSettings = settings(this.settings);
    if (newSettings != this.settings) {
      _settings = newSettings;
      ref.read(storageServiceProvider).saveSettings(newSettings);
      notifyListeners();
    }
    ref.read(workingProvider.notifier).state = '';
  }
}
