import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../editor/view_model.dart';

class ExpandAction extends ConsumerWidget {
  const ExpandAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expanded = ref.watch(expandAllProvider);
    return IconButton(
      icon: Icon(
        expanded ? Icons.unfold_less : Icons.unfold_more,
      ),
      tooltip: expanded ? 'Close All' : 'Expand All',
      onPressed: () =>
          ref.read(expandAllProvider.notifier).update((state) => !state),
    );
  }
}
