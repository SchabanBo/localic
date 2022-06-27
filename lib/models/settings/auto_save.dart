import 'dart:convert';

class AutoSave {
  final bool enabled;
  final int interval;
  final bool export;
  final ExportAs exportAs;

  AutoSave({
    this.enabled = false,
    this.interval = 60,
    this.export = true,
    this.exportAs = ExportAs.getX,
  });

  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
      'interval': interval,
      'export': export,
      'exportAs': exportAs.toString(),
    };
  }

  factory AutoSave.fromMap(Map<String, dynamic> map) {
    return AutoSave(
      enabled: map['enabled'],
      interval: map['interval'],
      export: map['export'],
      exportAs: map['exportAs'] == null
          ? ExportAs.getX
          : ExportAs.values
              .firstWhere((element) => map['exportAs'] == element.toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory AutoSave.fromJson(String source) =>
      AutoSave.fromMap(json.decode(source));

  AutoSave copyWith({
    bool? enabled,
    int? interval,
    bool? export,
    ExportAs? exportAs,
  }) {
    return AutoSave(
      enabled: enabled ?? this.enabled,
      interval: interval ?? this.interval,
      export: export ?? this.export,
      exportAs: exportAs ?? this.exportAs,
    );
  }
}

enum ExportAs {
  easyLocalization,
  getX,
}
