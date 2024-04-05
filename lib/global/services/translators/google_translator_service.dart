import 'package:dio/dio.dart';

import '../../../helpers/extensions/string_extension.dart';
import '../../../models/local_data/local.dart';
import '../../../ui/widgets/error_notification.dart';
import '../logging_service.dart';

class GoogleTranslatorService {
  final String apiKey;
  final Dio _dio = Dio();
  GoogleTranslatorService(this.apiKey);

  Future<LocalItem> translate(LocalItem item, String from) async {
    try {
      for (var i = 0; i < item.values.length; i++) {
        final key = item.values.keys.elementAt(i);
        if (key == from || item.values.values.elementAt(i).isNotEmpty) {
          continue;
        }
        final valueFrom = item.values[from];
        if (valueFrom.isNullOrEmpty) continue;
        item.values[key] = await getTranslation(valueFrom!, from, key);
      }
    } catch (e, s) {
      logger.e('Error Translating $e', error: e, stackTrace: s);
      showNotification('Error Translating', e.toString());
    }
    return item;
  }

  Future<String> getTranslation(String value, String from, String to) async {
    logger.d('Translating $value from $from to $to');
    final request = await _dio.get(
        'https://translation.googleapis.com/language/translate/v2',
        queryParameters: {
          'key': apiKey,
          'q': value,
          'target': to.substring(0, 2),
          'source': from.substring(0, 2),
        });
    if (request.statusCode != 200) {
      throw Exception(request.data.toString());
    }
    final result = request.data["data"]!["translations"]![0]!["translatedText"];
    return result;
  }
}
