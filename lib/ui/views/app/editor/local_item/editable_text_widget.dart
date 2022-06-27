import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _textStyle = TextStyle(fontSize: 18);

class QEditableText extends HookConsumerWidget {
  final isOpenProvider = StateProvider.autoDispose<bool>((_) => false);
  final String text;
  final Function(String) onEdit;
  QEditableText({required this.text, required this.onEdit, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    controller.text = text;
    final isOpen = ref.watch(isOpenProvider);

    final child = isOpen
        ? Focus(
            onFocusChange: (f) {
              if (!f) {
                onEdit(controller.text);
                ref.read(isOpenProvider.notifier).state = false;
              }
            },
            child: TextField(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(0),
                filled: true,
              ),
              autofocus: true,
              maxLines: null,
              controller: controller,
              onSubmitted: (_) {
                onEdit(controller.text);
                ref.read(isOpenProvider.notifier).state = false;
              },
              style: _textStyle,
            ),
          )
        : Container(
            decoration: BoxDecoration(
              color: controller.text.trim().isEmpty
                  ? Colors.red.withOpacity(0.5)
                  : null,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              controller.text,
              style: _textStyle,
            ),
          );

    return InkWell(
      onDoubleTap: () {
        ref.read(isOpenProvider.notifier).state = true;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (c, a) => SizeTransition(
              axisAlignment: 0,
              axis: Axis.vertical,
              sizeFactor: CurvedAnimation(
                parent: a,
                curve: Curves.slowMiddle,
              ),
              child: c),
          child: child,
        ),
      ),
    );
  }
}
