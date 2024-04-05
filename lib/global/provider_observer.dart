import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'services/logging_service.dart';

class ProviderLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    logger.d(
        '${provider.name ?? provider.runtimeType}: $previousValue -> $newValue');
  }

  @override
  void didDisposeProvider(
    ProviderBase provider,
    ProviderContainer container,
  ) {
    logger.d('${provider.name ?? provider.runtimeType}: disposed');
  }

  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) {
    logger
        .d('${provider.name ?? provider.runtimeType}: added with value $value');
  }
}
