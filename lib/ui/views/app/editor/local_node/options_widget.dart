import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:q_overlay/q_overlay.dart';

import '../../../../../helpers/constants.dart';
import '../view_model.dart';
import 'add_item.dart';
import 'view.dart';

class OptionsWidget extends ConsumerWidget {
  final LocalNodeVM vm;
  const OptionsWidget({required this.vm, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final node = ref.watch(vm);
    return Row(
      children: [
        AddLocalNode(indexMap: node.indexMap),
        const SizedBox(width: 5),
        AddLocalItem(indexMap: node.indexMap),
        const SizedBox(width: 5),
        InkWell(
          child: const Tooltip(
            message: 'Delete',
            child: Icon(
              Icons.delete_outline,
              color: AppColors.icon,
            ),
          ),
          onTap: () => QDialog(
            child: SizedBox(
              width: 250,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Are you sure you want to delete ${node.name}?'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Spacer(),
                        TextButton(
                            onPressed: QOverlay.dismissLast,
                            child: const Text('No')),
                        const SizedBox(width: 8),
                        TextButton(
                            onPressed: () {
                              ref
                                  .read(editorVMProvider)
                                  .removeNode(node.indexMap);
                              QOverlay.dismissLast();
                            },
                            child: const Text('Yes')),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ).show(),
        ),
      ],
    );
  }
}
