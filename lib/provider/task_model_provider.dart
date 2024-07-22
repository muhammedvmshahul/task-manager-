
import 'dart:collection';

import 'package:flutter/cupertino.dart';

import '../models/todo_model.dart';

class TodoProvider with ChangeNotifier {
//you can put one or two dummy task
  final List<TodoModel> _tasks = [];
//to get all the tasks
  UnmodifiableListView<TodoModel> get allTasks => UnmodifiableListView(_tasks);
//all new added task must be uncompleted
  void addTask(String task,String desc) {
    _tasks.add(TodoModel(todoTitle: task, completed: false, todoDesc:desc ));
    notifyListeners();
    // print(desc);
  }
//we are not working with task id that why we are working with every tasks index number to modify
  void toggleTask(TodoModel task) {
    final taskIndex = _tasks.indexOf(task);
    _tasks[taskIndex].toggleCompleted();
    notifyListeners();
  }
  void deleteTask(TodoModel task) {
    _tasks.remove(task);
    notifyListeners();
  }
  void editTask(TodoModel task, String newTitle, String newDesc) {
    final taskIndex = _tasks.indexOf(task);
    if (taskIndex != -1) {
      _tasks[taskIndex].todoTitle = newTitle;
      _tasks[taskIndex].todoDesc = newDesc;
      notifyListeners();
    }
  }
}