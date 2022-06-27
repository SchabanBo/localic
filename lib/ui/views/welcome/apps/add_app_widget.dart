import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../helpers/path_picker.dart';
import '../../../../models/settings/app_file.dart';
import '../../../widgets/error_notification.dart';
import '../../../widgets/widget_switcher.dart';
import 'view_model.dart';

class AddAppWidget extends ConsumerWidget {
  const AddAppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(appsVMProvider);
    final addingApp = ref.watch(vm.addingApp);
    return WidgetSwitcher(
      child: addingApp ? const _AddNewAppWidget() : const SizedBox.shrink(),
    );
  }
}

class _AddNewAppWidget extends HookConsumerWidget {
  const _AddNewAppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(appsVMProvider);
    final key = GlobalKey<FormState>();
    final appName = useTextEditingController();
    var appPath = '';
    var appExportPath = '';

    return Form(
      key: key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: appName,
                  decoration: const InputDecoration(hintText: 'App Name'),
                  validator: (s) {
                    if (s == null || s.isEmpty) return 'Name required';
                    if (vm.apps.any((e) => e.name == s)) {
                      return 'App already exist';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () async {
                  if (appPath.isEmpty && !kIsWeb) {
                    showNotification('Error', 'Path must be given');
                    return;
                  }
                  if (key.currentState!.validate()) {
                    vm.add(AppLocalFile(
                      name: appName.text,
                      path: appPath,
                      exportPath: appExportPath,
                    ));
                    ref.read(vm.addingApp.state).state = false;
                  }
                },
                child: const Text('Add'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  ref.read(vm.addingApp.state).state = false;
                },
                child: const Text('Cancel'),
              )
            ],
          ),
          kIsWeb
              ? const SizedBox.shrink()
              : PathPicker(
                  path: appPath,
                  title: 'Pick where to save the data',
                  type: PathType.file,
                  onChange: (s) => appPath = s,
                ),
          kIsWeb
              ? const SizedBox.shrink()
              : PathPicker(
                  path: appExportPath,
                  title: 'Pick where to export the data',
                  onChange: (s) => appExportPath = s,
                ),
        ],
      ),
    );
  }
}
