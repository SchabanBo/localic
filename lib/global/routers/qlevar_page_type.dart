import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class QlevarPageType {
  QCustomPage get type => QCustomPage(transitionsBuilder: _transitionsBuilder);

  Widget _transitionsBuilder(
    BuildContext context,
    Animation<double> a,
    Animation<double> aa,
    Widget child,
  ) =>
      SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: a,
          curve: Curves.fastOutSlowIn,
        )),
        child: child,
      );
}
