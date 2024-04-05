import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:q_overlay/q_overlay.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'global/routers/app_routes.dart';
import 'global/routers/qlevar_page_type.dart';
import 'helpers/constants.dart';
import 'ui/views/welcome/welcome_animation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  QR.settings.pagesType = QlevarPageType().type;
  runApp(
    const ProviderScope(
      //  observers: [ProviderLogger()],
      child: App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    QR.settings.initPage = const WelcomeAnimation();
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
        canvasColor: AppColors.background,
        cardColor: AppColors.node,
        dividerColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark)
            .copyWith(secondary: const Color(0xffB7B327), primary: Colors.amber)
            .copyWith(background: Colors.black),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith<Color?>((states) =>
              states.contains(MaterialState.selected) ? Colors.amber : null),
          trackColor: MaterialStateProperty.resolveWith<Color?>((states) =>
              states.contains(MaterialState.selected) ? Colors.amber : null),
        ),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color?>((states) =>
              states.contains(MaterialState.selected) ? Colors.amber : null),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color?>((states) =>
              states.contains(MaterialState.selected) ? Colors.amber : null),
        ),
      ),
    );
  }
}
