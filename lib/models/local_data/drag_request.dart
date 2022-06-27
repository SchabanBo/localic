import 'local.dart';

abstract class DragRequest {
  final List<int> hashMap;

  DragRequest(this.hashMap);
}

class ItemDragRequest extends DragRequest {
  final LocalItem item;
  ItemDragRequest(this.item, List<int> hashMap) : super(hashMap);
}

class NodeDragRequest extends DragRequest {
  final LocalNode node;
  NodeDragRequest(this.node, List<int> hashMap) : super(hashMap);
}
