import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../models/todo.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    super.key,
    required this.todo,
    required this.onDelete,
    required this.onEdit,
      });

  final Todo todo;
  final Function(Todo) onDelete;
  final Function(Todo) onEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.57,
          children: [
            SlidableAction(
              flex: 4,
              onPressed: (context) {
                onEdit(todo);
              },
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Editar',
            ),
            SlidableAction(
              flex: 4,
              onPressed: (context) {
                onDelete(todo);
              },
              backgroundColor: const Color(0xFFFF0000),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Deletar',
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          height: 60,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('dd/MM/yyyy - HH:mm').format(todo.dateTime),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      todo.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
