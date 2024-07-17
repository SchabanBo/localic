import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../helpers/constants.dart';
import '../view_model.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.node,
      ),
      child: const _Title(),
    );
  }
}

class _Title extends ConsumerWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final working = ref.watch(workingProvider);
    final title = working.isEmpty ? ref.watch(appVMProvider).app.name : working;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, color: AppColors.primary),
        ),
        working.isEmpty
            ? const SizedBox(height: 1)
            : const LinearProgressIndicator(minHeight: 1),
      ],
    );
  }
}
