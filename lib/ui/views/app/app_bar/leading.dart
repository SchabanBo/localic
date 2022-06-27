import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../helpers/constants.dart';
import '../view_model.dart';

class AppBarLeading extends HookConsumerWidget {
  const AppBarLeading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    controller.addListener(() {
      ref.read(filterProvider.notifier).state = controller.text;
    });
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search, color: AppColors.icon),
              hintText: 'Filter',
              fillColor: AppColors.icon,
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
