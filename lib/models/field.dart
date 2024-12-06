import 'package:shortest_route/models/path_segment.dart';
import 'package:shortest_route/models/point.dart';

class Field {
  late List<List<int>> rows = [];

  Field(List<String> field) {
    for (final rowString in field) {
      List<int> row = [];

      for (final cell in rowString.split('')) {
        if (cell == '.') {
          row.add(0);
        } else if (cell == 'X') {
          row.add(1);
        }
      }

      rows.add(row);
    }
  }

  int get(int x, int y) {
    return rows[y][x];
  }

  PathSegment findPath(
    Point point,
    Point end,
    PathSegment? parent,
    List<Point> visitedPoints,
  ) {
    final currentSegment = PathSegment(
      point: point,
      parent: parent,
      children: [],
    );

    if (point.x == end.x && point.y == end.y) {
      return currentSegment;
    }

    final freeNeighbors = getFreeNeighbors(point);

    for (final neighbor in freeNeighbors) {
      if (neighbor.hasVisited(visitedPoints)) {
        continue;
      }

      final neighborSegment = findPath(
        neighbor,
        end,
        currentSegment,
        [...visitedPoints, point],
      );

      currentSegment.children.add(neighborSegment);
    }

    return currentSegment;
  }

  List<Point> getFreeNeighbors(Point point) {
    final neighbors = [
      Point(point.x - 1, point.y - 1),
      Point(point.x, point.y - 1),
      Point(point.x + 1, point.y - 1),
      Point(point.x + 1, point.y),
      Point(point.x + 1, point.y + 1),
      Point(point.x, point.y + 1),
      Point(point.x - 1, point.y + 1),
      Point(point.x - 1, point.y),
    ];

    final maxRows = rows.length;
    final maxColumns = rows[0].length;

    List<Point> freeNeighbors = [];

    for (final neighbor in neighbors) {
      final inRange = neighbor.x >= 0 &&
          neighbor.y >= 0 &&
          neighbor.x < maxColumns &&
          neighbor.y < maxRows;

      if (inRange) {
        final isFree = get(neighbor.x, neighbor.y) == 0;

        if (isFree) {
          freeNeighbors.add(neighbor);
        }
      }
    }

    return freeNeighbors;
  }
}
