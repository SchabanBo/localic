import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../local_node/add_item.dart';
import '../view_model.dart';

const TextStyle _headerStyle = TextStyle(fontSize: 20);

class EditorHeaderWidget extends ConsumerWidget {
  const EditorHeaderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languages = ref.watch(editorVMProvider).locales.languages;
    return Container(
      padding: const EdgeInsets.only(bottom: 4),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF000000),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          const Expanded(child: Text('Keys', style: _headerStyle)),
          ...languages
              .map((l) => Expanded(child: Text(l, style: _headerStyle))),
          Row(
            children: const [
              SizedBox(width: 5),
              AddLocalNode(indexMap: [0]),
              SizedBox(width: 5),
              AddLocalItem(indexMap: [0]),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
