import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../models/local_data/drag_request.dart';
import '../../../../../models/local_data/local.dart';
import '../view_model.dart';

class LocalItemViewModel extends ChangeNotifier {
  final LocalItem item;
  final List<int> indexMap;
  final Ref ref;

  EditorViewModel get editorVM => ref.read(editorVMProvider.notifier);

  LocalItemViewModel(
    this.item,
    this.ref,
    List<int> indexMap,
  ) : indexMap = List.of(indexMap) {
    this.indexMap.add(item.hashCode);
    item.refresh = notifyListeners;
  }

  void updateValue(String language, String value) {
    if (value == item.values[language]) return;
    item.values[language] = value;
    notifyListeners();
    editorVM.updateLocalItem(indexMap, language, value);
  }

  void updateKey(String value) {
    if (value == item.name) return;
    if (editorVM.updateLocalItemKey(indexMap, value)) {
      item.name = value;
      notifyListeners();
    }
  }

  void handleDrag(DragTargetDetails<DragRequest> request) {
    editorVM.handleDrag(request.data, indexMap, item.hashCode);
  }
}
