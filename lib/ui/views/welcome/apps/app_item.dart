import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/settings/app_file.dart';
import 'view_model.dart';

class AppItem extends ConsumerWidget {
  final AppLocalFile app;
  final Animation<double> animation;
  const AppItem({required this.app, required this.animation, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizeTransition(
      sizeFactor: animation,
      child: ListTile(
        title: Text(app.name, style: Theme.of(context).textTheme.headline6),
        subtitle: kIsWeb ? null : Text(app.path),
        trailing: InkWell(
          onTap: () {
            ref.read(appsVMProvider).remove(app);
          },
          child:
              const Icon(Icons.delete, color: Color.fromARGB(100, 244, 67, 54)),
        ),
        onTap: () => ref.read(appsVMProvider).appSelected(app),
      ),
    );
  }
}
