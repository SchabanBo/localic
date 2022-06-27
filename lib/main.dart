import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:q_overlay/q_overlay.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'global/provider_observer.dart';
import 'global/routers/app_routes.dart';
import 'global/routers/qlevar_page_type.dart';
import 'ui/views/welcome/welcome_animation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  QR.settings.pagesType = QlevarPageType().type;
  runApp(
    ProviderScope(
      observers: [ProviderLogger()],
      child: const App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    QR.settings.iniPage = const WelcomeAnimation();
    final router = QRouterDelegate(
      AppRoutes(ref).routes,
      initPath: '/welcome',
    );
    QOverlay.navigationKey = router.key;
    return MaterialApp.router(
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.black,
        canvasColor: Colors.black,
        cardColor: const Color(0xFF161616),
        colorScheme:
            ColorScheme.fromSwatch(brightness: Brightness.dark).copyWith(
          secondary: const Color(0xffB7B327),
          primary: Colors.amber,
        ),
        toggleableActiveColor: Colors.amber,
        dividerColor: Colors.white,
      ),
    );
  }
}
