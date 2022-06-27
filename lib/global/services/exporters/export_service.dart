import 'dart:convert';

import '../../../models/local_data/json/data.dart';
import '../../../ui/widgets/error_notification.dart';
import '../storage_service.dart';

class ExportService {
  final JsonData data;
  final StorageService storage;

  ExportService({required this.data, required this.storage});

  void exportEasyLocalization(String toFolder) {
    try {
      for (var lan in data.data) {
        storage.writeFile('$toFolder/${lan.name}.json', lan.toJson());
      }
    } catch (e) {
      showNotification('Error Exporting', e.toString());
    }
  }

  void exportGetX(String toFile) {
    final String classContent = '''
// Code generated at ${DateTime.now()} by Qlevar Local Manager

class AppTranslation {
  static Map<String, Map<String, String>> translations = {${_getDataAsString()}  };
}
  ''';

    storage.writeFile('$toFile/locals.g.dart', classContent);
  }

  String _getDataAsString() {
    var result = '';
    for (var node in data.data) {
      result += '\n    "${node.name}": ${flatNodes('', node)},\n';
    }
    return result;
  }

  Map<String, String> flatNodes(String parent, JsonNode node) {
    final result = <String, String>{};
    parent = parent.isEmpty ? '' : '${parent}_';
    for (var child in node.children) {
      if (child is JsonNode) {
        result.addAll(flatNodes('$parent${child.name}', child));
      } else if (child is JsonItem) {
        result['\n      "$parent${child.name}"'] = jsonEncode(child.value);
      }
    }
    return result;
  }
}
