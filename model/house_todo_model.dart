class HouseTodo {
  int? id;
  String title;
  int categoryId;
  String categoryTitle;
  String summary;
  String? createdAt;
  bool isCompleted;
  bool showOnMain;

  HouseTodo({
    this.id,
    required this.title,
    required this.categoryId,
    required this.categoryTitle,
    required this.summary,
    this.createdAt,
    required this.isCompleted,
    required this.showOnMain,
  });
}
