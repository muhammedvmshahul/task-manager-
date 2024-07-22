import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager_provider/models/todo_model.dart';
import '../provider/task_model_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _showAddTextDialog(BuildContext context) async {
    TextEditingController _titleController = TextEditingController();
    TextEditingController _descController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add a new Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Add New Task",
                ),
                maxLength: null,
                maxLines: 2,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _descController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Add a description',
                ),
                maxLines: 3,
                maxLength: null,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Provider.of<TodoProvider>(context, listen: false).addTask(
                  _titleController.text,
                  _descController.text,
                );
                Navigator.pop(context);
                _titleController.clear();
                _descController.clear();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(120, 40),
              ),
              child: const Text("Submit"),
            )
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }

  Future<void> _showEditTextDialog(BuildContext context, TodoModel task) async {
    TextEditingController _titleController = TextEditingController(text: task.todoTitle);
    TextEditingController _descController = TextEditingController(text: task.todoDesc);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Edit Task Title",
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _descController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Edit Task Description',
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Provider.of<TodoProvider>(context, listen: false).editTask(
                  task,
                  _titleController.text,
                  _descController.text,
                );
                Navigator.of(context).pop();
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo App"),
      ),
      body: GestureDetector(
        onTap: () {
          // Handle tapping on a task here (if needed)
        },
        child: TodoAction(
          onEditTask: (task) {
            _showEditTextDialog(context, task);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTextDialog(context);
        },
        tooltip: "Add a todo",
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoAction extends StatelessWidget {
  final Function(TodoModel) onEditTask;

  const TodoAction({super.key, required this.onEditTask});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TodoProvider>(context);

    return ListView.builder(
      itemCount: taskProvider.allTasks.length,
      itemBuilder: (context, index) {
        final task = taskProvider.allTasks[index];

        return ListTile(
          leading: Checkbox(
            value: task.completed,
            onChanged: (_) => taskProvider.toggleTask(task),
          ),
          title: Text(task.todoTitle),
          subtitle: Text(task.todoDesc),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Call onEditTask callback when edit button is pressed
                  onEditTask(task);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => taskProvider.deleteTask(task),
              ),
            ],
          ),
        );
      },
    );
  }
}
