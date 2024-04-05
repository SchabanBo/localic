import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../helpers/constants.dart';
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.background,
            AppColors.border,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          const Expanded(child: Text('Keys', style: _headerStyle)),
          ...languages.map((l) =>
              Expanded(child: Center(child: Text(l, style: _headerStyle)))),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                SizedBox(width: 5),
                AddLocalNode(indexMap: [0]),
                SizedBox(width: 5),
                AddLocalItem(indexMap: [0]),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
