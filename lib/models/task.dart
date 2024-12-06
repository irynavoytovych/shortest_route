import 'package:shortest_route/models/field.dart';
import 'package:shortest_route/models/path_segment.dart';
import 'package:shortest_route/models/point.dart';
import 'package:shortest_route/models/result.dart';

class Task {
  final String id;
  final Field field;
  final Point start;
  final Point end;

  const Task({
    required this.id,
    required this.field,
    required this.start,
    required this.end,
  });

  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        field = Field(
            (json['field'] as List<dynamic>).map((e) => e as String).toList()),
        start = Point(json['start']['x'], json['start']['y']),
        end = Point(json['end']['x'], json['end']['y']);

  Result? solve() {
    final pathsTreeRoot = field.findPath(
      start,
      end,
      null,
      [],
    );

    final shortestPath = pathsTreeRoot.findPoint(end);

    if (shortestPath == null) {
      return null;
    }

    List<PathSegment> pathSegments = [];
    PathSegment? segment = shortestPath;

    while (segment != null) {
      pathSegments.add(segment);
      segment = segment.parent;
    }

    final steps = pathSegments.reversed.map((e) => e.point).toList();

    final path = steps.map((e) => '(${e.x},${e.y})').join('->');

    return Result(
      id: id,
      steps: steps,
      path: path,
    );
  }
}
