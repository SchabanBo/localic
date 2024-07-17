import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../models/local_data/drag_request.dart';
import '../../../../../models/local_data/local.dart';
import '../view_model.dart';

class LocalNodeViewModel extends ChangeNotifier {
  final LocalNode node;
  final List<int> indexMap;
  final AutoDisposeStateProvider<bool> isOpen;
  final Ref ref;
  final EditorViewModel editorVM;

  String get name => node.name;

  LocalNodeViewModel(
    this.node,
    this.ref,
    List<int> indexMap,
  )   : indexMap = List.from(indexMap),
        editorVM = ref.read(editorVMProvider),
        isOpen =
            StateProvider.autoDispose((ref) => ref.read(expandAllProvider)) {
    this.indexMap.add(node.hashCode);
    ref.listen<bool>(expandAllProvider, (previous, next) {
      ref.read(isOpen.notifier).state = next;
    });
    node.refresh = notifyListeners;
  }

  void toggleOpen() {
    ref.read(isOpen.notifier).update((state) => !state);
  }

  void updateName(String value) {
    if (value == name) return;
    node.name = value;
    notifyListeners();
  }

  void handleDrag(DragTargetDetails<DragRequest> request) {
    editorVM.handleDrag(request.data, indexMap, node.hashCode);
  }
}
