part of 'todos_bloc.dart';

@immutable
abstract class TodosEvent {}

class TodosFetchAll extends TodosEvent {
  TodosFetchAll();
}

class TodosFetchAllPinned extends TodosEvent {
  TodosFetchAllPinned();
}

class TodosAddItem extends TodosEvent {
  final HouseTodo item;
  TodosAddItem(this.item);
}

class TodosEditItem extends TodosEvent {
  final HouseTodo item;
  TodosEditItem(this.item);
}

class TodosDeleteItem extends TodosEvent {
  final int id;
  final int categoryId;

  TodosDeleteItem(this.id, this.categoryId);
}

class TodosToggleComplete extends TodosEvent {
  final int id;
  final bool status;
  TodosToggleComplete(this.id, this.status);
}

class TodosFetchCategories extends TodosEvent {
  TodosFetchCategories();
}

class TodosAddCategory extends TodosEvent {
  final HouseTodoCategory item;
  TodosAddCategory(this.item);
}

class TodosEditCategory extends TodosEvent {
  final HouseTodoCategory item;
  TodosEditCategory(this.item);
}

class TodosDeleteCategory extends TodosEvent {
  final int id;
  final List<String> taskIds;
  TodosDeleteCategory(this.id, this.taskIds);
}

class TodosToggleShowCatOnMain extends TodosEvent {
  final String id;
  final bool status;
  TodosToggleShowCatOnMain(this.id, this.status);
}
