import 'package:flutter/material.dart';
import 'package:shortest_route/models/point.dart';
import 'package:shortest_route/models/task.dart';
import 'package:shortest_route/models/result.dart';

class PreviewScreen extends StatefulWidget {
  final Result result;
  final Task task;

  const PreviewScreen({
    super.key,
    required this.result,
    required this.task,
  });

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  late int fieldSize;

  @override
  void initState() {
    super.initState();

    fieldSize = widget.task.field.rows.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview screen'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: fieldSize,
              ),
              shrinkWrap: true,
              itemCount: fieldSize * fieldSize,
              itemBuilder: (context, index) {
                final row = index % fieldSize;
                final column = (index / fieldSize).floor();

                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: getColor(row, column),
                  ),
                  child: Center(
                    child: Text(
                      '($row,$column)',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
            Text(widget.result.path),
          ],
        ),
      ),
    );
  }

  Color getColor(int x, int y) {
    Point? currentStep;

    for (final step in widget.result.steps) {
      if (step.x == x && step.y == y) {
        currentStep = step;
      }
    }

    if (widget.task.field.get(x, y) == 1) {
      return const Color(0xFF000000);
    } else if (widget.task.end.x == x && widget.task.end.y == y) {
      return const Color(0xFF009688);
    } else if (widget.task.start.x == x && widget.task.start.y == y) {
      return const Color(0xFF64FFDA);
    } else if (currentStep != null) {
      return const Color(0xFF4CAF50);
    }
    return Colors.white;
  }
}
