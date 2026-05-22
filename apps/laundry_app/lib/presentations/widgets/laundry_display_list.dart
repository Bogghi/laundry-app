import 'package:flutter/material.dart';

class LaundryDisplayList extends StatelessWidget {
  final List<Widget> children;

  const LaundryDisplayList({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children.asMap().entries.map((entry) {
        int index = entry.key;
        Widget child = entry.value;

        return Container(
          margin: const EdgeInsets.only(bottom: 5),
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: elementBorderRadius(index, children.length),
            color: Colors.grey[200],
          ),
          child: child,
        );
      }).toList(),
    );
  }

  BorderRadius elementBorderRadius(int index, int length) {
    final Radius topLeft, topRight, bottomLeft, bottomRight;
    final outsideCorner = Radius.circular(10.0);
    final innersideCorner = Radius.circular(4.0);

    if(index == 0 && length == 1) {
      topLeft = outsideCorner;
      topRight = outsideCorner;
      bottomLeft = outsideCorner;
      bottomRight = outsideCorner;
    } else if(index == 0) {
      topLeft = outsideCorner;
      topRight = outsideCorner;
      bottomLeft = innersideCorner;
      bottomRight = innersideCorner;
    }
    else if(index == length-1) {
      topLeft = innersideCorner;
      topRight = innersideCorner;
      bottomLeft = outsideCorner;
      bottomRight = outsideCorner;
    }
    else {
      topLeft = innersideCorner;
      topRight = innersideCorner;
      bottomLeft = innersideCorner;
      bottomRight = innersideCorner;
    }

    return BorderRadius.only(
      topLeft: topLeft,
      topRight: topRight,
      bottomLeft: bottomLeft,
      bottomRight: bottomRight,
    );
  }
}
