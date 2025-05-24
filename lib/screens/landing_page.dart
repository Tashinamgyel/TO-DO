import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/model/task.dart';
import 'package:todo/user_input/user_input.dart';
import 'package:todo/model/disintegrating_effect.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<StatefulWidget> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  static const Color primaryColor = Color.fromARGB(255, 194, 108, 79);
  static const Color backgroundColor = Color.fromARGB(255, 38, 38, 36);
  static const Color cardColor = Color.fromARGB(210, 255, 255, 255);
  late List<Task> taskList = [];

  @override
  void initState() {
    _loadTasks();
    super.initState();
  }

  Future<void> _loadTasks() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? taskJsonList = prefs.getStringList('tasks') ?? [];
      setState(() {
        taskList = taskJsonList
            .map((jsonString) => Task.fromJson(jsonDecode(jsonString)))
            .toList();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading tasks: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error loading tasks."),
        ),
      );
    }
  }

  Future<void> _saveTasks() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> taskJsonList =
          taskList.map((task) => jsonEncode(task.toJson())).toList();
      await prefs.setStringList('tasks', taskJsonList);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving tasks: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error saving tasks."),
      ));
    }
  }

  void removeTask(String id) {
    setState(() {
      taskList.removeWhere((task) => task.id == id);
    });
    _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: true,
        title: const Text(
          'TO;DO',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ),
      body: taskList.isEmpty
          ? const Center(
              child: Text(
                'No tasks yet. Add one!',
                style: TextStyle(
                    color: Color.fromARGB(255, 194, 108, 79), fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                return UserInput(
                    task: taskList[index],
                    removeM: removeTask,
                    saveTasks: _saveTasks);
              }),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.7),
              spreadRadius: 1,
              blurRadius: 16,
              offset: const Offset(5, 5),
            ),
            BoxShadow(
              color: const Color.fromARGB(255, 194, 108, 79).withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 15,
              offset: const Offset(5, 5),
            ),
          ],
        ),
        child: FloatingActionButton(
          shape: const CircleBorder(),
          splashColor: const Color.fromARGB(255, 194, 108, 79).withOpacity(0.4),
          backgroundColor: primaryColor,
          onPressed: () {
            setState(() {
              taskList.add(
                Task(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    task: '',
                    isChecked: false),
              );
            });
            _saveTasks();
          },
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
