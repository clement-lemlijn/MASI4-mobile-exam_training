import 'package:flutter/material.dart';
import '../widgets/task_list_item.dart';
import '../widgets/quote_widget.dart';
import '../services/database_helper.dart';
import '../models/task.dart';
import 'task_list_screen.dart';
import 'task_form_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late Future<List<Task>> _futureTasks;
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    setState(() {
      _futureTasks = DatabaseHelper.instance.getAllTasks().then((tasks) {
        _tasks = tasks;
        return tasks;
      });
    });
  }

  Future<void> _toggleDone(Task task) async {
    task.isDone = !task.isDone;
    await DatabaseHelper.instance.updateTask(task);
    _loadTasks();
  }

  Future<void> _deleteTask(Task task) async {
    if (task.id != null) {
      await DatabaseHelper.instance.deleteTask(task.id!);
      _loadTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mes tâches")),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              "Organise, priorise, réalise...",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: QuoteWidget(),
          ),
          Expanded(
            child: FutureBuilder<List<Task>>(
              future: _futureTasks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Erreur : ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Aucune tâche."));
                } else {
                  return ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return TaskListItem(
                        task: task,
                        onToggleDone: _toggleDone,
                        onDelete: _deleteTask,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TaskFormScreen()),
          );
          _loadTasks(); // Rafraichir la liste de tâches après le retour
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
