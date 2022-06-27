import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../helpers/constants.dart';
import '../../../../../helpers/path_picker.dart';
import '../../../../../models/settings/auto_save.dart';
import '../../view_model.dart';

class ExportIcon extends StatelessWidget {
  const ExportIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () =>
          showDialog(context: context, builder: (_) => const ExportView()),
      icon: const Icon(
        Icons.upload,
        color: AppColors.icon,
      ),
      tooltip: 'Export Data',
    );
  }
}

class ExportView extends ConsumerWidget {
  const ExportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Export Data', style: TextStyle(fontSize: 18)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ExportAsWidget(),
          const SizedBox(height: 8),
          kIsWeb
              ? const SizedBox.shrink()
              : PathPicker(
                  path: ref.read(_pathProvider),
                  title: 'Export to',
                  onChange: (s) => ref.read(_pathProvider.notifier).state = s,
                ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel')),
        TextButton(
          onPressed: () {
            _export(ref);
            Navigator.pop(context);
          },
          child: const Text('Export'),
        ),
      ],
    );
  }

  void _export(WidgetRef ref) {
    ref.read(appVMProvider).export(
          path: ref.read(_pathProvider),
          exportAs: ref.read(_exportAsProvider),
        );
  }
}

class ExportAsWidget extends ConsumerWidget {
  const ExportAsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exportAs = ref.watch(_exportAsProvider);

    return Column(children: [
      for (final e in ExportAs.values)
        RadioListTile<ExportAs>(
          title: Text(e.name),
          value: e,
          groupValue: exportAs,
          onChanged: (v) => ref.read(_exportAsProvider.notifier).state = v!,
        )
    ]);
  }
}

final _exportAsProvider =
    StateProvider.autoDispose((ref) => ExportAs.easyLocalization);
final _pathProvider =
    StateProvider.autoDispose((ref) => ref.read(appVMProvider).app.exportPath);
