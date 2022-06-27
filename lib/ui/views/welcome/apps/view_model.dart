import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../../../global/services/settings_service.dart';
import '../../../../models/settings/app_file.dart';
import 'app_item.dart';

class AppViewModel extends ChangeNotifier {
  final List<AppLocalFile> apps;
  final addingApp = StateProvider((_) => false);
  final Ref ref;
  final listKey = GlobalKey<AnimatedListState>();

  AppViewModel(this.ref) : apps = ref.read(settingsProvider).settings.apps;

  void add(AppLocalFile app) {
    listKey.currentState!.insertItem(apps.length);
    apps.add(app);
    notifyListeners();
  }

  void remove(AppLocalFile app) {
    listKey.currentState!.removeItem(
      apps.indexOf(app),
      (context, animation) => AppItem(app: app, animation: animation),
    );
    apps.remove(app);
    notifyListeners();
  }

  Future appSelected(AppLocalFile app) async {
    ref.read(settingsProvider).saveSettings((s) => s.copyWith(apps: apps));
    QR.to('/app/${app.name}');
  }
}

final appsVMProvider = ChangeNotifierProvider.autoDispose<AppViewModel>((ref) {
  return AppViewModel(ref);
});
