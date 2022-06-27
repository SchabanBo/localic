import 'package:dio/dio.dart';

import '../../../models/local_data/local.dart';
import '../../../ui/widgets/error_notification.dart';

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
        item.values[key] = await getTranslation(item.values[from]!, from, key);
      }
    } on Exception catch (e) {
      showNotification('Error Translating', e.toString());
    }
    return item;
  }

  Future<String> getTranslation(String value, String from, String to) async {
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
