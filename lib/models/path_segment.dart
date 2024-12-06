import 'dart:collection';
import 'package:shortest_route/models/point.dart';

class PathSegment {
  final Point point;
  final PathSegment? parent;
  final List<PathSegment> children;

  PathSegment({
    required this.point,
    required this.parent,
    required this.children,
  });

  PathSegment? findPoint(Point targetPoint) {
    final queue = Queue<PathSegment>();
    queue.add(this);

    while (queue.isNotEmpty) {
      final currentNode = queue.removeFirst();

      if (currentNode.point.x == targetPoint.x &&
          currentNode.point.y == targetPoint.y) {
        return currentNode;
      }

      for (final child in currentNode.children) {
        queue.add(child);
      }
    }

    return null;
  }
}
