import 'package:flutter/material.dart';

import '../../languages/language_icon.dart';
import '../../settings/settings_icon.dart';
import 'exit.dart';
import 'expand.dart';
import 'export.dart';
import 'import.dart';
import 'save.dart';

class AppBarActions extends StatelessWidget {
  const AppBarActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Spacer(),
        SaveAction(),
        ImportIcon(),
        ExportIcon(),
        ExpandAction(),
        LanguageIcon(),
        SettingsIcon(),
        ExitIcon(),
      ],
    );
  }
}
