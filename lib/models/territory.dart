import 'package:flutter/material.dart';

/// Who currently controls a territory.
/// NOTE: Will be replaced by a full Clan model in a later phase.
enum Owner { player, enemy, neutral }

/// A node in the world graph: a city/territory positioned with
/// normalized 0..1 coordinates over the map area.
class TerritoryNode {
  final String name;
  final Offset pos;
  Owner owner;
  int defense;

  TerritoryNode(this.name, this.pos, this.owner, this.defense);
}
