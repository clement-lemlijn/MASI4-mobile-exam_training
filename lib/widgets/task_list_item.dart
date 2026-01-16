import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final Function(Task) onToggleDone;
  final Function(Task) onDelete;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onToggleDone,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(task.id),
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Icon(Icons.delete, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Supprimer",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(task),
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            decoration:
            task.isDone ? TextDecoration.lineThrough : TextDecoration.none,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.dueDate != null)
              Text(
                "Échéance : ${DateFormat('dd/MM/yyyy').format(task.dueDate!)}",
                style: const TextStyle(fontSize: 12),
              ),
            Text(
              "Priorité : ${task.priority}",
              style: const TextStyle(fontSize: 12),
            ),
            if (task.note != null && task.note!.isNotEmpty)
              Text(
                "Note : ${task.note}",
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
        trailing: Checkbox(
          value: task.isDone,
          onChanged: (_) => onToggleDone(task),
        ),
      ),
    );
  }
}
