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

  Future<void> _handleMenu(String value) async {
    switch (value) {
      case "clear_done":
        await DatabaseHelper.instance.deleteCompletedTasks();
        _loadTasks(); // rafraîchir la liste
        break;

      case "sort_date":
        setState(() {
          _tasks.sort((a, b) {
            if (a.dueDate == null && b.dueDate == null) return 0;
            if (a.dueDate == null) return 1;
            if (b.dueDate == null) return -1;
            return a.dueDate!.compareTo(b.dueDate!);
          });
        });
        break;

      case "sort_priority":
        setState(() {
          _tasks.sort((a, b) => b.priority.compareTo(a.priority));
        });
        break;

      case "sort_name":
        setState(() {
          _tasks.sort((a, b) => a.title.compareTo(b.title));
        });
        break;

      case "about":
        await Navigator.pushNamed(context, '/about');
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes tâches"),
        actions: [
          PopupMenuButton<String>(
          onSelected: _handleMenu,
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: "clear_done",
                  child: Text("Supprimer les tâches terminées")),
              PopupMenuItem(
                  value: "sort_date", child: Text("Trier par date")),
              PopupMenuItem(
                  value: "sort_priority", child: Text("Trier par priorité")),
              PopupMenuItem(value: "sort_name", child: Text("Trier par nom")),
              PopupMenuItem(value: "about", child: Text("À propos")),
            ],
          ),
        ],
      ),
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
