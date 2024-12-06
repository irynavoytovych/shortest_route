class Point {
  final int x;
  final int y;

  const Point(this.x, this.y);

  bool hasVisited(List<Point> visitedPoints) {
    for (final visitedPoint in visitedPoints) {
      if (x == visitedPoint.x && y == visitedPoint.y) {
        return true;
      }
    }

    return false;
  }
}
