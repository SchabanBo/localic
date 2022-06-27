import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../ui/views/app/view.dart' deferred as deferred_app;
import '../../ui/views/welcome/view.dart';
import 'middleware/deferred_loader.dart';
import 'middleware/settings_middleware.dart';

class AppRoutes {
  static const welcome = 'welcome';
  static const app = '/app/:name';
  final WidgetRef ref;
  late final settingsLoadingMiddleware = SettingsLoadingMiddleware(ref);

  AppRoutes(this.ref);

  late final routes = [
    QRoute(
      name: welcome,
      path: '/welcome',
      builder: () => const WelcomeView(),
      middleware: [settingsLoadingMiddleware],
    ),
    QRoute(
      name: app,
      path: '/app/:name',
      builder: () => deferred_app.AppView(),
      middleware: [
        DeferredLoader(() => deferred_app.loadLibrary()),
        settingsLoadingMiddleware
      ],
    ),
  ];
}
