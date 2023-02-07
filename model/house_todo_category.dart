class HouseTodoCategory {
  int? id;
  String title;
  int tasksNum = 0;
  bool showOnMain = false;
  List<String> taskIds;

  HouseTodoCategory({
    this.id,
    required this.title,
    required this.tasksNum,
    required this.showOnMain,
    required this.taskIds,
  });
}
