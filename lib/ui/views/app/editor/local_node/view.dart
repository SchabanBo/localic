import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../helpers/constants.dart';
import '../../../../../models/local_data/drag_request.dart';
import '../../../../../models/local_data/local.dart';
import '../../../../widgets/widget_switcher.dart';
import '../../view_model.dart';
import '../local_item/editable_text_widget.dart';
import '../local_item/view.dart';
import '../view_model.dart';
import 'options_widget.dart';
import 'view_model.dart';

typedef LocalNodeVM = AutoDisposeChangeNotifierProvider<LocalNodeViewModel>;

class _ViewModelParameters {
  final LocalNode node;
  final List<int> indexMap;

  _ViewModelParameters(this.node, this.indexMap);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _ViewModelParameters &&
        other.node == node &&
        listEquals(other.indexMap, indexMap);
  }

  @override
  int get hashCode => node.hashCode ^ indexMap.hashCode;
}

final _viewModel = ChangeNotifierProvider.autoDispose
    .family<LocalNodeViewModel, _ViewModelParameters>((ref, parameters) {
  ref.onDispose(() {
    parameters.node.refresh = null;
  });
  return LocalNodeViewModel(parameters.node, ref, parameters.indexMap);
});

class LocalNodeWidget extends ConsumerWidget {
  final LocalNode node;
  final List<int> indexMap;

  const LocalNodeWidget({
    required this.node,
    required this.indexMap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = _viewModel(_ViewModelParameters(node, indexMap));
    return _DraggableLocalNode(vm: vm);
  }
}

class _DraggableLocalNode extends ConsumerWidget {
  final LocalNodeVM vm;
  const _DraggableLocalNode({
    required this.vm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(vm);
    final dragRequest = NodeDragRequest(viewModel.node, viewModel.indexMap);
    final child = _NodeContainer(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 8),
          Draggable<NodeDragRequest>(
            feedback: const SizedBox.shrink(),
            data: dragRequest,
            childWhenDragging:
                const Icon(Icons.drag_handle, color: AppColors.primary),
            child: const Icon(Icons.drag_handle, color: AppColors.icon),
          ),
          const SizedBox(width: 8),
          Expanded(child: _LocalNodeWidget(vm: vm)),
        ],
      ),
    );

    return DragTarget<DragRequest>(
      onWillAccept: (data) {
        return data != null &&
            data != dragRequest &&
            _notSameParent(List.of(data.hashMap), viewModel.indexMap);
      },
      onAccept: viewModel.handleDrag,
      builder: (c, data, _) {
        if (data.isEmpty) return child;

        return Column(
          children: [
            dragContainer,
            child,
          ],
        );
      },
    );
  }

  bool _notSameParent(List<int> left, List<int> right) {
    // remove node index
    left.removeLast();
    if (left.length != right.length) return true;

    for (var i = 0; i < left.length - 1; i++) {
      if (left[i] != right[i]) return true;
    }
    return false;
  }
}

class _NodeContainer extends StatelessWidget {
  final Widget child;
  const _NodeContainer({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.node,
        border: Border(
          left: BorderSide(color: AppColors.border),
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: child,
    );
  }
}

class _LocalNodeWidget extends ConsumerWidget {
  final LocalNodeVM vm;
  const _LocalNodeWidget({
    required this.vm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _LocalNodeHeader(vm: vm),
        _LocalNodeBody(vm: vm),
      ],
    );
  }
}

class _LocalNodeHeader extends ConsumerWidget {
  final LocalNodeVM vm;
  const _LocalNodeHeader({required this.vm, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final node = ref.watch(vm);
    final isOpen = ref.watch(ref.read(vm.notifier).isOpen);
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: QEditableText(
            text: node.name,
            onEdit: ref.read(vm.notifier).updateName,
          ),
        ),
        Expanded(
          flex: ref.read(editorVMProvider).locales.languages.length,
          child: InkWell(
            onTap: ref.read(vm.notifier).toggleOpen,
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                isOpen ? Icons.expand_less : Icons.expand_more,
                size: 30,
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),
        OptionsWidget(vm: vm),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _LocalNodeBody extends ConsumerWidget {
  final LocalNodeVM vm;
  late final childrenProvider = Provider.autoDispose<List<LocalBase>>((ref) {
    final filter = ref.watch(filterProvider);
    return ref
        .watch(vm)
        .node
        .children
        .where((element) => element.filter(filter))
        .toList();
  });
  _LocalNodeBody({required this.vm, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(vm);
    final isOpen = ref.watch(value.isOpen);
    final children = ref.watch(childrenProvider);

    return WidgetSwitcher(
      child: isOpen
          ? children.isEmpty
              ? _noChildren
              : Column(
                  children: [
                    for (final child in children)
                      if (child is LocalItem)
                        LocalItemWidget(
                          key: ValueKey(child.hashCode),
                          item: child,
                          indexMap: value.indexMap,
                        )
                      else
                        LocalNodeWidget(
                          key: ValueKey(child.hashCode),
                          node: child as LocalNode,
                          indexMap: value.indexMap,
                        ),
                  ],
                )
          : const SizedBox(),
    );
  }
}

const _noChildren =
    Padding(padding: EdgeInsets.all(8.0), child: Text('No Children'));
