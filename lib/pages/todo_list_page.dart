import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/repositories/todo_repository.dart';

import '../widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = [];
  Todo? deletedTodo;
  int? deletedTodoPos;
  String? errorText;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  bool get isErrorText => errorText != null;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Lista de Tarefas',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          backgroundColor: const Color(0xff00d7f3),
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: todoController,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: 'Adicione uma tarefa',
                                  hintText: 'Ex. Ir para Academia',
                                  errorText: errorText,
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xff00d7f3),
                                      width: 2,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: isErrorText
                                        ? const Color(0xFFFF0000)
                                        : const Color(0xff00d7f3),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                String text = todoController.text;
                                if (text.isEmpty) {
                                  setState(() {
                                    errorText = 'O título não pode ser vazio';
                                  });
                                  return;
                                }
                                setState(() {
                                  Todo newTodo = Todo(
                                      title: text, dateTime: DateTime.now());
                                  todos.add(newTodo);
                                  errorText = null;
                                });
                                todoController.clear();
                                todoRepository.saveTodoList(todos);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff00d7f3),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.all(16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Icon(Icons.add),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: constraint.minHeight * 0.53,
                          child: todos.isEmpty
                              ? Center(
                                  child: Container(
                                    width: constraint.minWidth * 0.7,
                                    height: constraint.minHeight * 0.4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                            'assets/nenhuma_tarefa.png'),
                                        const Text(
                                          'Nenhuma tarefa',
                                          style: TextStyle(
                                              fontSize: 23,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : ListView(shrinkWrap: true, children: [
                                  for (Todo todo in todos)
                                    TodoListItem(
                                      todo: todo,
                                      onDelete: onDelete,
                                    ),
                                ]),
                        ),
                        const SizedBox(height: 16),
                        Row(children: [
                          Expanded(
                              child: Text(
                                  'Você possui ${todos.length} tarefas pendentes')),
                          const SizedBox(width: 8),
                          ElevatedButton(
                              onPressed: showDeleteTodosConfirmationDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff00d7f3),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.all(14.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Limpar tudo'))
                        ])
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Tarefa "${todo.title}" foi removida com sucesso',
        style: const TextStyle(color: Color(0xFF060708)),
      ),
      backgroundColor: Colors.white,
      action: SnackBarAction(
        label: 'Desfazer',
        textColor: const Color(0xFF00d7f3),
        onPressed: () {
          setState(() {
            todos.insert(deletedTodoPos!, deletedTodo!);
          });
          todoRepository.saveTodoList(todos);
        },
      ),
      duration: const Duration(seconds: 5),
    ));
  }

  void showDeleteTodosConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar tudo?'),
        content: const Text('Você tem certeza que deseja apagar todas as tarefas?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF00d7f3),
              ),
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteAllTodos();
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFFF0000),
              ),
              child: const Text('Limpar tudo')),
        ],
      ),
    );
  }

  void deleteAllTodos() {
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }

}
