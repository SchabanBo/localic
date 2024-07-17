import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/local_data/local.dart';
import 'header/view.dart';
import 'local_item/view.dart';
import 'local_node/view.dart';
import 'view_model.dart';

class EditorView extends ConsumerWidget {
  const EditorView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loader = ref.watch(localesLoaderProvider);
    return loader.when(
      data: (data) => const _Editor(),
      error: (e, s) => Text(e.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _Editor extends HookConsumerWidget {
  const _Editor();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(editorVMProvider);
    final records = ref.watch(localesRecordsProvider);
    final controller = useScrollController();
    return Column(
      children: [
        const EditorHeaderWidget(),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            controller: controller,
            children: [
              for (final record in records)
                if (record is LocalItem)
                  LocalItemWidget(
                    key: ValueKey(record.hashCode),
                    item: record,
                    indexMap: const [0],
                  )
                else
                  LocalNodeWidget(
                    key: ValueKey(record.hashCode),
                    node: record as LocalNode,
                    indexMap: const [0],
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
