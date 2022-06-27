import 'dart:convert';

import 'models.dart';

class Settings {
  final List<AppLocalFile> apps;
  final TranslationSettings translation;
  final AutoSave autoSave;
  Settings({
    required this.apps,
    required this.translation,
    required this.autoSave,
  });

  factory Settings.defaults() => Settings(
        apps: [],
        translation: TranslationSettings(),
        autoSave: AutoSave(),
      );

  Map<String, dynamic> toMap() {
    return {
      'apps': apps.map((x) => x.toMap()).toList(),
      'translation': translation.toMap(),
      'autoSave': autoSave.toMap(),
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      apps: List<AppLocalFile>.from(
          map['apps']?.map((x) => AppLocalFile.fromMap(x))),
      translation: map['translation'] == null
          ? TranslationSettings()
          : TranslationSettings.fromMap(map['translation']),
      autoSave: map['autoSave'] == null
          ? AutoSave()
          : AutoSave.fromMap(map['autoSave']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Settings.fromJson(String source) =>
      Settings.fromMap(json.decode(source));

  Settings copyWith({
    List<AppLocalFile>? apps,
    TranslationSettings? translation,
    AutoSave? autoSave,
  }) {
    return Settings(
      apps: apps ?? this.apps,
      translation: translation ?? this.translation,
      autoSave: autoSave ?? this.autoSave,
    );
  }
}
