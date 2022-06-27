import 'package:flutter/material.dart';

import '../../../helpers/extensions/context_extensions.dart';

class WelcomeAnimation extends StatefulWidget {
  const WelcomeAnimation({Key? key}) : super(key: key);

  @override
  State<WelcomeAnimation> createState() => _WelcomeAnimationState();
}

class _WelcomeAnimationState extends State<WelcomeAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 2500),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<Offset> _floatingAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0, 0.05),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  ));

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width,
      height: context.height * 0.3,
      child: SlideTransition(
        position: _floatingAnimation,
        child: Image.asset(
          'assets/images/app_name.png',
        ),
      ),
    );
  }
}
