import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/local_data/local.dart';
import '../editor/view_model.dart';
import '../view_model.dart';

final languageVMProvider =
    ChangeNotifierProvider.autoDispose<LanguageViewModel>((ref) {
  final editorVM = ref.watch(editorVMProvider.notifier);
  ref.onDispose(() {
    final app = ref.read(appVMProvider);
    app.saveData();
  });
  return LanguageViewModel(editorVM);
});

class LanguageViewModel extends ChangeNotifier {
  final EditorViewModel editorVM;

  LanguageViewModel(this.editorVM);

  QlevarLocal get locales => editorVM.locales;
  List<String> get languages => locales.languages;

  void refresh() {
    notifyListeners();
    editorVM.refresh();
  }

  void addLanguage(String language) {
    languages.add(language);
    locales.ensureAllLanguagesExist(locales.languages);
    refresh();
  }

  void removeLanguage(String language) {
    locales.languages.remove(language);
    locales.removeLanguage(language);
    refresh();
  }

  void updateLanguage(String oldLanguage, String newLanguage) {
    locales.languages.remove(oldLanguage);
    locales.languages.add(newLanguage);
    locales.updateLanguage(oldLanguage, newLanguage);
    refresh();
  }

  void moveLanguage(String language, int direction) {
    final index = languages.indexOf(language);
    if (direction == -1) {
      if (index == 0) return;
      languages.removeAt(index);
      languages.insert(index + direction, language);
    } else {
      if (index == languages.length - 1) return;
      languages.removeAt(index);
      languages.insert(index + direction, language);
    }
    refresh();
  }
}
