import 'package:flutter/material.dart';

class LaundryGrid extends StatelessWidget {
  final int itemCount;
  final Widget Function(int index, BorderRadius borderRadius) itemBuilder;
  final int crossAxisCount;
  final double childAspectRatio;

  const LaundryGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.65,
  });

  @override
  Widget build(BuildContext context) {
    final totalRows = (itemCount / crossAxisCount).ceil();

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      childAspectRatio: childAspectRatio,
      children: List.generate(itemCount, (index) {
        final row = index ~/ crossAxisCount;
        final col = index % crossAxisCount;
        final borderRadius = _gridElementBorderRadius(
          row,
          col,
          totalRows,
          crossAxisCount,
        );
        return itemBuilder(index, borderRadius);
      }),
    );
  }

  BorderRadius _gridElementBorderRadius(
    int row,
    int col,
    int totalRows,
    int totalCols,
  ) {
    const outsideCorner = Radius.circular(10.0);
    const innerCorner = Radius.circular(4.0);

    final isTopEdge = row == 0;
    final isBottomEdge = row == totalRows - 1;
    final isLeftEdge = col == 0;
    final isRightEdge = col == totalCols - 1;

    return BorderRadius.only(
      topLeft: (isTopEdge && isLeftEdge) ? outsideCorner : innerCorner,
      topRight: (isTopEdge && isRightEdge) ? outsideCorner : innerCorner,
      bottomLeft: (isBottomEdge && isLeftEdge) ? outsideCorner : innerCorner,
      bottomRight: (isBottomEdge && isRightEdge) ? outsideCorner : innerCorner,
    );
  }
}
