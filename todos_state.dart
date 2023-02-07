part of 'todos_bloc.dart';

@immutable
abstract class TodosState {}

class HTodosInitial extends TodosState {
  HTodosInitial();
}

class HTodosLoadInprogress extends TodosState {
  HTodosLoadInprogress();
}

class HTodosLoadAllSuccess extends TodosState {
  final Map<String, HouseTodo> allHTodos;
  final Map<String, HouseTodoCategory> allCategories;

  HTodosLoadAllSuccess({required this.allHTodos, required this.allCategories});
}

class HTodosLoadFailure extends TodosState {
  final String error;
  HTodosLoadFailure({required this.error});
}

class HTodosLoadCategoriesSuccess extends TodosState {
  final Map<String, HouseTodoCategory> allCategories;

  HTodosLoadCategoriesSuccess({required this.allCategories});
}
