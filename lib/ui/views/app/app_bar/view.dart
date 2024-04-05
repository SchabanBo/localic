import 'package:flutter/widgets.dart';

import '../../../../helpers/constants.dart';
import 'actions/view.dart';
import 'leading.dart';
import 'title.dart';

class AppBarView extends StatelessWidget implements PreferredSizeWidget {
  const AppBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: const Row(
        children: [
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
