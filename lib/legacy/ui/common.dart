import 'package:flutter/material.dart';

class AnimatedMenuItem extends StatefulWidget {
  const AnimatedMenuItem(
    this.child,
    this.route, {
    super.key,
  });

  final Widget child;
  final Future<void> Function() route;

  @override
  _AnimatedMenuItemState createState() => _AnimatedMenuItemState();
}

class _AnimatedMenuItemState extends State<AnimatedMenuItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 150,
      ),
    );
    _animation = _controller.drive(
      Tween<double>(
        begin: 1,
        end: 1.1,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onHighlightChanged: (bool c) => _controller.reverse(),
      onTapDown: (TapDownDetails d) => _controller.forward(),
      onTap: widget.route,
      child: ScaleTransition(
        scale: _animation,
        child: widget.child,
      ),
    );
  }
}
