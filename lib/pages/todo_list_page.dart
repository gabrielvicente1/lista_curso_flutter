import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';

import '../widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();

  List<Todo> todos = [];
  Todo? deletedTodo;
  int? deletedTodoPos;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Lista de Tarefas',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600)),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: todoController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Adicione uma tarefa',
                                  hintText: 'Ex. Ir para Academia',
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                String text = todoController.text;
                                setState(() {
                                  Todo newTodo =
                                      Todo(title: text, dateTime: DateTime.now());
                                  todos.add(newTodo);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff00d7f3),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.all(16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Icon(Icons.add),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Flexible(
                          child: ListView(shrinkWrap: true, children: [
                            for (Todo todo in todos)
                              TodoListItem(
                                todo: todo,
                                onDelete: onDelete,
                              ),
                          ]),
                        ),
                        SizedBox(height: 16),
                        Row(children: [
                          Expanded(
                              child: Text(
                                  'Você possui ${todos.length} tarefas pendentes')),
                          SizedBox(width: 8),
                          ElevatedButton(
                              onPressed: showDeleteTodosConfirmationDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff00d7f3),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.all(14.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text('Limpar tudo'))
                        ])
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });
    todos.remove(todo);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Tarefa ${todo.title} foi removida com sucesso',
        style: TextStyle(color: Color(0xFF060708)),
      ),
      backgroundColor: Colors.white,
      action: SnackBarAction(
        label: 'Desfazer',
        textColor: const Color(0xFF00d7f3),
        onPressed: () {
          setState(() {
            todos.insert(deletedTodoPos!, deletedTodo!);
          });
        },
      ),
      duration: const Duration(seconds: 5),
    ));
  }

  void showDeleteTodosConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar tudo?'),
        content: Text('Você tem certeza que deseja apagar toas as tarefas?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF00d7f3),
              ),
              child: Text('Cancelar')),
          TextButton(onPressed: () {
            Navigator.of(context).pop();
            deleteAllTodos();
          },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFFF0000),
              ),
              child: Text('Limpar tudo')),
        ],
      ),
    );
  }
  void deleteAllTodos() {
    setState(() {
      todos.clear();
    });

  }
 }