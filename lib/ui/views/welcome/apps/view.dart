import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_app_widget.dart';
import 'app_item.dart';
import 'view_model.dart';

class AppSelector extends ConsumerWidget {
  const AppSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(appsVMProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select app',
                  style: Theme.of(context).textTheme.headline5,
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(vm.addingApp.state).state = true;
                  },
                  child: const Text('Add app'),
                ),
              ],
            ),
            const Divider(),
            const AddAppWidget(),
            AnimatedList(
              key: vm.listKey,
              initialItemCount: vm.apps.length,
              shrinkWrap: true,
              itemBuilder: (c, i, a) => AppItem(app: vm.apps[i], animation: a),
            )
          ],
        ),
      ),
    );
  }
}
