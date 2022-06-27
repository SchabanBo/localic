import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../helpers/constants.dart';
import '../../../../../models/local_data/drag_request.dart';
import '../../../../../models/local_data/local.dart';
import 'editable_text_widget.dart';
import 'options_widget.dart';
import 'view_model.dart';

typedef LocalItemVM = AutoDisposeChangeNotifierProvider<LocalItemViewModel>;

class LocalItemWidget extends ConsumerWidget {
  final LocalItem item;
  final List<int> indexMap;

  const LocalItemWidget({
    required this.item,
    required this.indexMap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ChangeNotifierProvider.autoDispose((ref) {
      ref.onDispose(() {
        item.refresh = null;
      });
      return LocalItemViewModel(item, ref, indexMap);
    });
    return _DraggableLocalItem(vm: vm);
  }
}

class _DraggableLocalItem extends ConsumerWidget {
  final LocalItemVM vm;
  const _DraggableLocalItem({
    required this.vm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(vm);
    final dragRequest = ItemDragRequest(viewModel.item, viewModel.indexMap);
    final child = _ItemContainer(
      child: Row(
        children: [
          const SizedBox(width: 8),
          Draggable<ItemDragRequest>(
            feedback: const SizedBox.shrink(),
            data: dragRequest,
            childWhenDragging:
                const Icon(Icons.drag_handle, color: AppColors.primary),
            child: const Icon(Icons.drag_handle, color: AppColors.icon),
          ),
          Expanded(child: _LocalItemWidget(vm: vm)),
        ],
      ),
    );
    return DragTarget<DragRequest>(
      onWillAccept: (data) => data is DragRequest && data != dragRequest,
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
}

class _ItemContainer extends StatelessWidget {
  final Widget child;
  const _ItemContainer({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.item,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: child,
    );
  }
}

class _LocalItemWidget extends ConsumerWidget {
  final LocalItemVM vm;
  const _LocalItemWidget({
    required this.vm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vmValue = ref.watch(vm);
    final name = vmValue.item.name;
    return Row(
      children: [
        const SizedBox(width: 8),
        Expanded(
          child: QEditableText(
            text: name,
            onEdit: vmValue.updateKey,
          ),
        ),
        ...vmValue.editorVM.locales.languages.map((l) {
          final value = vmValue.item.values[l] ?? '';
          return Expanded(
            child: QEditableText(
              key: Key("${l}_$value"),
              text: value,
              onEdit: (s) => vmValue.updateValue(l, s),
            ),
          );
        }),
        OptionsWidget(vm: vm),
        const SizedBox(width: 8),
      ],
    );
  }
}
