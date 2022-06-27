import 'package:flutter/material.dart';

import '../../helpers/constants.dart';

class WidgetSwitcher extends StatelessWidget {
  final Widget child;
  const WidgetSwitcher({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: animationDuration,
      transitionBuilder: (c, a) => SizeTransition(
        sizeFactor: CurvedAnimation(
          curve: Curves.easeInOutBack,
          parent: a,
        ),
        child: c,
      ),
      child: child,
    );
  }
}
