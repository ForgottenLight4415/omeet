import 'package:flutter/material.dart';

class ScalingTile extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const ScalingTile({Key? key, required this.onPressed, required this.child}) : super(key: key);

  @override
  _ScalingTileState createState() => _ScalingTileState();
}

class _ScalingTileState extends State<ScalingTile> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200), lowerBound: 0.0, upperBound: 0.1)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  void _tapDown(TapDownDetails details) {
    _animationController!.forward();
  }

  void _tapCancel() {
    _animationController!.reverse();
  }

  void _tapUp(TapUpDetails details) {
    _animationController!.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _animationController!.forward().whenComplete(
              () => _animationController!.reverse().whenComplete(
                    widget.onPressed,
                  ),
            );
      },
      onTapDown: _tapDown,
      onTapUp: _tapUp,
      onTapCancel: _tapCancel,
      child: Transform.scale(
        scale: 1 - _animationController!.value,
        child: widget.child,
      ),
    );
  }
}
