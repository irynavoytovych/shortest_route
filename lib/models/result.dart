import 'package:shortest_route/models/point.dart';

class Result {
  final String id;
  final List<Point> steps;
  final String path;

  Result({
    required this.id,
    required this.steps,
    required this.path,
  });

  Result.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        steps = (json['result']?['steps'] as List<dynamic>? ?? [])
            .map((step) => Point(
          int.parse(step['x'] ?? '0'),
          int.parse(step['y'] ?? '0'),
        ))
            .toList(),
        path = json['result']?['path'] ?? '';
}
