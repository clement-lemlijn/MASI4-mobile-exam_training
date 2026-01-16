import 'package:flutter/material.dart';
import '../widgets/task_list_item.dart';
import '../widgets/quote_widget.dart';
import '../services/database_helper.dart';
import '../models/task.dart';
import 'task_list_screen.dart';
import '../models/task.dart';
import 'package:intl/intl.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _id;
  String _title = "";
  int _priority = 3;
  DateTime? _dueDate;
  String? _note;
  bool _isDone = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _id = widget.task!.id;
      _title = widget.task!.title;
      _priority = widget.task!.priority;
      _dueDate = widget.task!.dueDate;
      _note = widget.task!.note;
      _isDone = widget.task!.isDone;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(_id == null ? "Nouvelle tâche" : "Modifier tâche"),
    ),
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              initialValue: _title,
              decoration: InputDecoration(labelText: "Titre"),
              validator: (value) => (value == null || value.isEmpty)
                  ? "Champ obligatoire"
                  : null,
              onSaved: (value) => _title = value!,
            ),
            DropdownButtonFormField<int>(
              initialValue: _priority,
              items: List.generate(
                5,
                    (i) => DropdownMenuItem(
                  value: i + 1,
                  child: Text("Priorité ${i + 1}"),
                ),
              ),
              onChanged: (value) => setState(() {
                _priority = value!;
              }),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _dueDate == null
                        ? "Aucune échéance"
                        : "Échéance : ${DateFormat('dd/MM/yyyy').format(_dueDate!)}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _dueDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      setState(() => _dueDate = pickedDate);
                    }
                  },
                ),
                if (_dueDate != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    tooltip: "Supprimer la date",
                    onPressed: () {
                      setState(() => _dueDate = null);
                    },
                  ),
              ],
            ),
            TextFormField(
              initialValue: _note,
              decoration: InputDecoration(labelText: "Note"),
              onSaved: (value) => _note = value,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  final newTask = Task(
                    id: _id,
                    title: _title,
                    priority: _priority,
                    dueDate: _dueDate,
                    note: _note,
                    isDone: _isDone,
                  );

                  if (_id == null) {
                    await DatabaseHelper.instance.insertTask(newTask);
                  } else {
                    await DatabaseHelper.instance.updateTask(newTask);
                  }

                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: Text("Valider"),
            ),
          ],
        ),
      ),
    ),
  );
}