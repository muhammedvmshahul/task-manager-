class TodoModel {
  String todoTitle;
  String todoDesc;
  bool completed;
  TodoModel({required this.todoTitle, this.completed = false,required this.todoDesc});
// to toggle the task
  void toggleCompleted() {
    completed = !completed;
  }
}