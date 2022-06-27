import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../services/settings_service.dart';

class SettingsLoadingMiddleware extends QMiddleware {
  final WidgetRef ref;

  SettingsLoadingMiddleware(this.ref);

  @override
  Future<void> onEnter() async {
    final service = ref.read(settingsProvider);
    if (service.loaded) return;
    await service.load(ref);
    final s = ref.read(settingsProvider);
    print(s.loaded);
  }
}
