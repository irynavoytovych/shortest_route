import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shortest_route/models/result.dart';
import 'package:shortest_route/models/task.dart';
import 'package:shortest_route/screens/result_list_screen.dart';
import 'package:shortest_route/models/api_response.dart';

class ProcessScreen extends StatefulWidget {
  final String url;
  final List<Task> tasks;

  const ProcessScreen({
    super.key,
    required this.url,
    required this.tasks,
  });

  @override
  State<ProcessScreen> createState() => _ProcessScreenState();
}

class _ProcessScreenState extends State<ProcessScreen> {
  bool isLoading = false;

  String? errorMessage;

  int completedTasks = 0;

  List<Result> results = [];

  @override
  void initState() {
    super.initState();

    solveTasks();
  }

  void solveTasks() {
    for (final task in widget.tasks) {
      final result = task.solve();

      if (result != null) {
        results.add(result);
      }

      setState(() {
        completedTasks++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Process screen',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (completedTasks == widget.tasks.length)
                      const Text(
                        'All calculations has finished, you can send your result to server',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 8),
                    Text(
                      '${(completedTasks / widget.tasks.length * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(
                        value: completedTasks / widget.tasks.length,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (errorMessage != null)
                      Text(
                        errorMessage!,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
              ),
              if (isLoading) const CircularProgressIndicator(),
              ElevatedButton(
                onPressed: isLoading ? null : handleSendButton,
                child: const Text('Send result to server'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleSendButton() {
    sendRequest();
  }

  Future<void> sendRequest() async {
    try {
      setState(() {
        isLoading = true;
      });

      final url = Uri.parse(widget.url);
      final content = jsonEncode(
        results
            .map((e) => {
                  "id": e.id,
                  "result": {
                    "steps": e.steps
                        .map((e) => {
                              "x": e.x,
                              "y": e.y,
                            })
                        .toList(),
                    "path": e.path,
                  }
                })
            .toList(),
      );

      final response = await post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: content,
      );

      Map<String, dynamic> json = jsonDecode(response.body);

      final submitResponse = SubmitResultResponse.fromJson(json);

      if (response.statusCode == 200 && !submitResponse.error) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ResultListScreen(
                tasks: widget.tasks,
                results: results,
              );
            },
          ),
        );
      } else {
        setState(() {
          errorMessage = 'Error';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error ${e.toString()}';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    // print(submitResponse);
  }
}
