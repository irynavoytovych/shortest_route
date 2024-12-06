import 'package:flutter/material.dart';
import 'package:shortest_route/models/task.dart';
import 'package:shortest_route/screens/preview_screen.dart';
import 'package:shortest_route/models/result.dart';

class ResultListScreen extends StatefulWidget {
  final List<Task> tasks;
  final List<Result> results;

  const ResultListScreen({
    super.key,
    required this.tasks,
    required this.results,
  });

  @override
  State<ResultListScreen> createState() => _ResultListScreenState();
}

class _ResultListScreenState extends State<ResultListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result list screen'),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16.0),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: widget.results.length,
          itemBuilder: (BuildContext context, int index) {
            Result result = widget.results[index];
            Task task = widget.tasks[index];

            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return PreviewScreen(result: result, task: task);
                    },
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  result.path,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
