import 'package:flutter/material.dart';
import './scaling_tile.dart';

class BaseCard extends StatelessWidget {
  final VoidCallback onPressed;
  final Card card;

  const BaseCard(
      {Key? key,
        required this.onPressed,
        required this.card})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScalingTile(
      onPressed: onPressed,
      child: card,
    );
  }
}