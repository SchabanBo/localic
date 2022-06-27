import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/download/download.dart'
    if (dart.library.html) '../../helpers/download/download_web.dart';
import '../../models/local_data/json/data.dart';
import '../../models/local_data/local.dart';
import '../../models/settings/app_file.dart';
import '../../models/settings/settings.dart';
import '../../ui/widgets/error_notification.dart';

const _key = 'localic_settings';

final storageServiceProvider = Provider<StorageService>(
  (ref) => StorageService(),
);

class StorageService {
  Future<Settings?> loadSettings() async {
    final pref = await SharedPreferences.getInstance();
    if (pref.containsKey(_key)) {
      return Settings.fromJson(pref.getString(_key)!);
    }
    return null;
  }

  Future saveSettings(Settings settings) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(_key, settings.toJson());
  }

  Future<QlevarLocal?> loadLocals(AppLocalFile appLocalFile) async {
    if (kIsWeb) {
      return await _loadLocalsWeb(appLocalFile);
    }

    try {
      final file = File(appLocalFile.path);
      if (!(await file.exists())) await file.create(recursive: true);
      var data = await File(appLocalFile.path).readAsString();
      if (data.isEmpty) data = '{"en":{}}';
      final l = JsonData.fromJson(data);
      return QlevarLocal.fromData(l);
    } catch (e) {
      showNotification('Error reading locales', e.toString());
    }
    return null;
  }

  Future<QlevarLocal?> _loadLocalsWeb(AppLocalFile appLocalFile) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final key = '${_key}_${appLocalFile.name}';
      if (!pref.containsKey(key)) await pref.setString(key, '{"en":{}}');
      final data = pref.getString(key)!;
      final l = JsonData.fromJson(data);
      return QlevarLocal.fromData(l);
    } catch (e) {
      showNotification('Error reading locales', e.toString());
    }
    return null;
  }

  Future<void> saveLocals(AppLocalFile file, String data) async {
    if (kIsWeb) return await _saveLocalsWeb(file, data);
    if (!await File(file.path).exists()) {
      await File(file.path).create(recursive: true);
    }
    await File(file.path).writeAsString(data);
  }

  Future<void> _saveLocalsWeb(AppLocalFile file, String local) async {
    final pref = await SharedPreferences.getInstance();
    final key = '${_key}_${file.name}';
    await pref.setString(key, local);
  }

  void writeFile(String path, String data) async {
    if (kIsWeb) {
      _writeFileWeb(path, data);
      return;
    }
    final file = File(path);
    if (!(await file.exists())) await file.create(recursive: true);
    await file.writeAsString(data);
  }

  void _writeFileWeb(String path, String data) async {
    downloadFile(path, data);
  }

  Future<String?> readFile(String path) async {
    final file = File(path);
    if (!(await file.exists())) return null;
    return await file.readAsString();
  }

  Future<void> importLocalsWeb(String name, String data) async {
    final pref = await SharedPreferences.getInstance();
    final key = '${_key}_$name';
    await pref.setString(key, data);
  }

  Future<void> exportLocalsWeb(AppLocalFile file, QlevarLocal local) async {
    _writeFileWeb(' ${file.name}.json', local.toData().toJson());
  }
}
