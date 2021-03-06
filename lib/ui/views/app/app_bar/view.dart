import 'package:flutter/widgets.dart';

import 'actions/view.dart';
import 'leading.dart';
import 'title.dart';

class AppBarView extends StatelessWidget with PreferredSizeWidget {
  const AppBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF010101),
      child: Row(
        children: const [
          Expanded(child: AppBarLeading()),
          Expanded(child: TitleWidget()),
          Expanded(child: AppBarActions()),
        ],
      ),
    );
  }

  @override
  final preferredSize = const Size.fromHeight(75);
}
