import 'package:qlevar_router/qlevar_router.dart';

/// This middleware used for web, the javascript data for the page will only
/// be loaded when the user navigate to this page
/// See https://medium.com/@SchabanBo/reduce-your-flutter-web-app-loading-time-8018d8f442
class DeferredLoader extends QMiddleware {
  final Future<dynamic> Function() loader;

  DeferredLoader(this.loader);
  @override
  Future onEnter() async {
    await loader();
  }
}
