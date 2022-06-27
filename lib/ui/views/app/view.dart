import 'package:flutter/material.dart';

import 'app_bar/view.dart';
import 'editor/view.dart';

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarView(),
      body: EditorView(),
    );
  }
}
