import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../global/services/storage_service.dart';
import '../../../../models/local_data/drag_request.dart';
import '../../../../models/local_data/local.dart';
import '../../../widgets/error_notification.dart';
import '../view_model.dart';

final localesLoaderProvider =
    FutureProvider.autoDispose<QlevarLocal>((ref) async {
  final app = ref.read(appVMProvider).app;
  final locales = await ref.read(storageServiceProvider).loadLocals(app);
  return locales ?? QlevarLocal();
});

final editorVMProvider =
    ChangeNotifierProvider.autoDispose<EditorViewModel>((ref) {
  final locales = ref.watch(localesLoaderProvider).value!;
  return EditorViewModel(ref, locales);
});

final localesRecordsProvider =
    StateProvider.autoDispose<List<LocalBase>>((ref) {
  final all = ref.watch(editorVMProvider).locales.children;
  final filter = ref.watch(filterProvider);
  if (filter.isEmpty) return all;

  return all.where((locale) => locale.filter(filter)).toList();
});

final expandAllProvider = StateProvider<bool>((ref) => false);

class EditorViewModel extends ChangeNotifier {
  final QlevarLocal locales;
  final Ref ref;
  EditorViewModel(this.ref, this.locales) {
    locales.refresh = notifyListeners;
  }

  @override
  void dispose() {
    locales.refresh = null;
    super.dispose();
  }

  void removeItem(List<int> hashMap, {bool update = true}) {
    LocalNode node = locales;
    for (var i = 1; i < hashMap.length - 1; i++) {
      node = node.nodes.firstWhere((e) => e.hashCode == hashMap[i]);
    }
    final item = node.items.firstWhere((e) => e.hashCode == hashMap.last);
    node.children.remove(item);
    if (update) {
      node.refresh?.call();
    }
  }

  void addItem(List<int> hashMap, LocalItem item, {int? itemHashCode}) {
    LocalNode node = locales;
    for (var i = 1; i < hashMap.length; i++) {
      node = node.nodes.firstWhere((e) => e.hashCode == hashMap[i]);
    }
    if (node.items.any((e) => e.name == item.name)) {
      showNotification('Error', 'Key with name ${item.name} already exist');
      return;
    }
    item.ensureAllLanguagesExist(locales.languages);
    if (item.values.entries.first.value.isEmpty) {
      item.values[locales.languages.first] = item.name;
    }

    if (itemHashCode != null) {
      node.children.insert(
          node.children.indexWhere((e) => e.hashCode == itemHashCode), item);
    } else {
      node.children.add(item);
    }
    refresh();
  }

  void addNode(List<int> hashMap, LocalNode newNode, {int? insertIndex}) {
    LocalNode node = locales;
    for (var i = 1; i < hashMap.length; i++) {
      node = node.nodes.firstWhere((e) => e.hashCode == hashMap[i]);
    }
    if (node.items.any((e) => e.name == newNode.name)) {
      showNotification('Error', 'Key with name ${node.name} already exist');
      return;
    }
    if (insertIndex != null) {
      node.children.insert(
          node.children.indexWhere((e) => e.hashCode == insertIndex), newNode);
    } else {
      node.children.add(newNode);
    }

    refresh();
  }

  void updateLocalItem(List<int> hashMap, String language, String value) {
    LocalNode node = locales;
    for (var i = 1; i < hashMap.length - 1; i++) {
      node = node.nodes.firstWhere((e) => e.hashCode == hashMap[i]);
    }
    final item = node.items.firstWhere((e) => e.hashCode == hashMap.last);
    item.values[language] = value;
  }

  bool updateLocalItemKey(List<int> hashMap, String value) {
    LocalNode node = locales;
    for (var i = 1; i < hashMap.length - 1; i++) {
      node = node.nodes.firstWhere((e) => e.hashCode == hashMap[i]);
    }
    if (node.items.any((e) => e.hashCode != hashMap.last && e.name == value)) {
      showNotification('Error', 'Key with name $value already exist');
      return false;
    }
    final item = node.items.firstWhere((e) => e.hashCode == hashMap.last);
    item.name = value;
    return true;
  }

  void removeNode(List<int> hashMap, {bool update = true}) {
    LocalNode node = locales;
    for (var i = 1; i < hashMap.length - 1; i++) {
      node = node.nodes.firstWhere((e) => e.hashCode == hashMap[i]);
    }
    final item = node.nodes.firstWhere((e) => e.hashCode == hashMap.last);
    node.children.remove(item);
    if (update) {
      node.refresh?.call();
    }
  }

  void refresh() => notifyListeners();

  /// handle drag request for an item or node
  /// [request] the request which contains the info from the object to move
  /// [indexMap] the path in the tree to the new location
  /// [insertIndex] the index in the node to insert the object at
  void handleDrag(DragRequest request, List<int> indexMap, int insertIndex) {
    switch (request.runtimeType) {
      case ItemDragRequest:
        _handleItemDrag(request as ItemDragRequest, indexMap, insertIndex);
        break;
      case NodeDragRequest:
        _handleNodeDrag(request as NodeDragRequest, indexMap, insertIndex);
        break;
    }
  }

  void _handleItemDrag(
    ItemDragRequest request,
    List<int> indexMap,
    int insertIndex,
  ) {
    removeItem(request.hashMap, update: false);
    final map = List.of(indexMap)..removeLast();
    addItem(
      map,
      request.item,
      itemHashCode: insertIndex,
    );
  }

  void _handleNodeDrag(
    NodeDragRequest request,
    List<int> indexMap,
    int insertIndex,
  ) {
    removeNode(request.hashMap, update: false);
    final map = List.of(indexMap)..removeLast();
    addNode(
      map,
      request.node,
      insertIndex: insertIndex,
    );
  }
}
