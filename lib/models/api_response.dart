import 'package:shortest_route/models/task.dart';

class GetTasksResponse {
  final bool error;
  final String message;
  final List<Task> data;

  const GetTasksResponse({
    required this.error,
    required this.message,
    required this.data,
  });

  GetTasksResponse.fromJson(Map<String, dynamic> json)
      : error = json['error'],
        message = json['message'],
        data = (json['data'] as List<dynamic>)
            .map((e) => Task.fromJson(e))
            .toList();
}

class SubmitResultResponse {
  final bool error;
  final String message;
  final List<ResultVerification> data;

  const SubmitResultResponse({
    required this.error,
    required this.message,
    required this.data,
  });

  SubmitResultResponse.fromJson(Map<String, dynamic> json)
      : error = json['error'],
        message = json['message'] == null || (json['message'] as String).isEmpty
            ? (json['error'] as bool)
                ? json['data']['message']
                : null
            : json['message'],
        data = !(json['error'] as bool)
            ? (json['data'] as List<dynamic>)
                .map((e) => ResultVerification.fromJson(e))
                .toList()
            : [];
}

class ResultVerification {
  final String id;
  final bool correct;

  const ResultVerification({
    required this.id,
    required this.correct,
  });

  ResultVerification.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        correct = json['correct'];
}
