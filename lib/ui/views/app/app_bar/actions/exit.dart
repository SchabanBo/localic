import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../../../../helpers/constants.dart';

class ExitIcon extends StatelessWidget {
  const ExitIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Exit App',
      onPressed: () {
        QR.back();
      },
      icon: const Icon(
        Icons.logout,
        color: AppColors.icon,
      ),
    );
  }
}
