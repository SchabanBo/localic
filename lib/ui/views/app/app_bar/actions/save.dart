import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../global/services/storage_service.dart';
import '../../../../../helpers/constants.dart';
import '../../editor/view_model.dart';
import '../../view_model.dart';

class SaveAction extends ConsumerWidget {
  const SaveAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        kIsWeb
            ? IconButton(
                tooltip: 'Download',
                onPressed: () {
                  ref.read(appVMProvider).saveData();
                  final editorVM = ref.read(editorVMProvider);
                  ref.read(storageServiceProvider).exportLocalsWeb(
                      ref.read(appVMProvider).app, editorVM.locales);
                },
                icon: const Icon(
                  Icons.download_for_offline,
                  color: AppColors.icon,
                ),
              )
            : const SizedBox.shrink(),
        IconButton(
          tooltip: 'Save',
          onPressed: () => ref.read(appVMProvider).saveData(),
          icon: const Icon(
            Icons.save,
            color: AppColors.icon,
          ),
        ),
      ],
    );
  }
}
