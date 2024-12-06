import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shortest_route/models/api_response.dart';
import 'package:shortest_route/screens/process_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController urlController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String? errorMessage;

  bool isLoading = false;

  String? validateUrl(String? value) {
    const pattern =
        r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)';
    final regex = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return 'URL cannot be empty';
    } else if (!regex.hasMatch(value)) {
      return 'Set valid API base URL in order to continue';
    }
    return null;
  }

  Future<void> sendRequest(String url) async {
    try {
      isLoading = true;

      final uri = Uri.parse(url);
      final response = await get(uri);

      Map<String, dynamic> json = jsonDecode(response.body);

      final tasksResponse = GetTasksResponse.fromJson(json);

      if (response.statusCode == 200 && !tasksResponse.error) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ProcessScreen(
                url: url,
                tasks: tasksResponse.data,
              );
            },
          ),
        );
      } else {
        setState(() {
          errorMessage = tasksResponse.message;
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
  }

  void handleStartButton() {
    final url = urlController.text.trim();

    if (formKey.currentState!.validate()) {
      setState(() {
        errorMessage = null;
      });

      sendRequest(url);
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //
  //   urlController.text = 'https://flutter.webspark.dev/flutter/api';
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFormField(
                  controller: urlController,
                  decoration: InputDecoration(
                      labelText: 'API URL',
                      border: const OutlineInputBorder(),
                      errorText: errorMessage),
                  validator: validateUrl,
                ),
                if (isLoading) const CircularProgressIndicator(),
                ElevatedButton(
                  onPressed: isLoading ? null : handleStartButton,
                  child: const Text(
                    'Start counting process',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
