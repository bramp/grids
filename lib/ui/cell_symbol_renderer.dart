import 'package:flutter/material.dart';

import 'package:grids/engine/cell.dart';

/// A widget responsible for rendering the visual representation of a [Cell].
class CellSymbolRenderer extends StatelessWidget {
  const CellSymbolRenderer({required this.cell, super.key});
  final Cell cell;

  @override
  Widget build(BuildContext context) {
    if (cell is NumberCell) {
      return _buildNumber(cell as NumberCell);
    } else if (cell is DiamondCell) {
      return _buildDiamond(cell as DiamondCell);
    }

    return const SizedBox.shrink();
  }

  Widget _buildNumber(NumberCell numberCell) {
    return Text(
      numberCell.number.toString(),
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: numberCell.color != null
            ? _getColor(numberCell.color!)
            : Colors.white,
      ),
    );
  }

  Widget _buildDiamond(DiamondCell diamond) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          // Rotate a square 45 degrees to make a diamond
          transform: Matrix4.rotationZ(0.785398), // 45 degrees in radians
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: _getColor(diamond.color),
            borderRadius: BorderRadius.circular(4), // Slightly rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColor(CellColor color) {
    switch (color) {
      case CellColor.red:
        return Colors.redAccent;
      case CellColor.black:
        return Colors.black87;
      case CellColor.blue:
        return Colors.blueAccent;
      case CellColor.yellow:
        return Colors.amber;
    }
  }
}
