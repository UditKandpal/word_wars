import 'package:flutter/material.dart';
import '../models/territory.dart';

/// A tappable territory node rendered over the map.
class TerritoryNodeWidget extends StatelessWidget {
  final TerritoryNode node;
  final bool attackable;
  final VoidCallback onTap;

  const TerritoryNodeWidget({
    super.key,
    required this.node,
    required this.attackable,
    required this.onTap,
  });

  Color get _ownerColor => switch (node.owner) {
        Owner.player => Colors.blue,
        Owner.enemy => Colors.red.shade700,
        Owner.neutral => Colors.blueGrey.shade600,
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 68,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: _ownerColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: attackable ? Colors.amber : Colors.black54,
            width: attackable ? 2.5 : 1,
          ),
          boxShadow: attackable
              ? [BoxShadow(color: Colors.amber.withOpacity(0.5), blurRadius: 8)]
              : null,
        ),
        child: Text(
          node.name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
