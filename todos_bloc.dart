import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:meta/meta.dart';
import 'package:selvie/bloc/house_bloc/house_todos_bloc/repository/house_todos_repository.dart';
import 'package:selvie/bloc/house_bloc/house_todos_bloc/model/house_todo_category.dart';
import 'package:selvie/bloc/house_bloc/house_todos_bloc/model/house_todo_model.dart';

part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final htodosRepository = HTodosRepository();

  TodosBloc() : super(HTodosInitial()) {
    on<TodosFetchAll>(onFetchAllHTodos, transformer: sequential());
    on<TodosFetchCategories>(onFetchAllHCategories, transformer: sequential());
    on<TodosAddCategory>(onAddCategory, transformer: sequential());
    on<TodosEditCategory>(onEditCategory, transformer: sequential());
    on<TodosDeleteCategory>(onDeleteCategory, transformer: sequential());
    on<TodosAddItem>(onAddItem, transformer: sequential());
    on<TodosEditItem>(onEditItem, transformer: sequential());
    on<TodosDeleteItem>(onDeleteItem, transformer: sequential());
    on<TodosToggleComplete>(onToggleItemCompleteStatus,
        transformer: sequential());
  }

  FutureOr<void> onFetchAllHTodos(
    TodosFetchAll event,
    Emitter<TodosState> emit,
  ) async {
    emit(HTodosLoadInprogress());

    try {
      final htodosResponse = await htodosRepository.fetchAllHTasks();
      final hCategoriesResponse = await htodosRepository.fetchAllHCategories();
      emit(HTodosLoadAllSuccess(
        allHTodos: htodosResponse,
        allCategories: hCategoriesResponse,
      ));
    } catch (e) {
      print(e);
      emit(HTodosLoadFailure(error: e.toString()));
    }
  }

  FutureOr<void> onFetchAllHCategories(
    TodosFetchCategories event,
    Emitter<TodosState> emit,
  ) async {
    emit(HTodosLoadInprogress());

    try {
      final hCategoriesResponse = await htodosRepository.fetchAllHCategories();
      emit(HTodosLoadCategoriesSuccess(
        allCategories: hCategoriesResponse,
      ));
    } catch (e) {
      print(e);
      emit(HTodosLoadFailure(error: e.toString()));
    }
  }

  FutureOr<void> onAddCategory(
    TodosAddCategory event,
    Emitter<TodosState> emit,
  ) async {
    emit(HTodosLoadInprogress());

    try {
      final hCategoriesResponse =
          await htodosRepository.addCategory(event.item);
      emit(HTodosLoadCategoriesSuccess(
        allCategories: hCategoriesResponse,
      ));
    } catch (e) {
      emit(HTodosLoadFailure(error: e.toString()));
    }
  }

  FutureOr<void> onEditCategory(
    TodosEditCategory event,
    Emitter<TodosState> emit,
  ) async {
    emit(HTodosLoadInprogress());

    try {
      final hCategoriesResponse =
          await htodosRepository.editCategory(event.item);
      emit(HTodosLoadCategoriesSuccess(
        allCategories: hCategoriesResponse,
      ));
    } catch (e) {
      emit(HTodosLoadFailure(error: e.toString()));
    }
  }

  FutureOr<void> onDeleteCategory(
    TodosDeleteCategory event,
    Emitter<TodosState> emit,
  ) async {
    emit(HTodosLoadInprogress());

    try {
      final hCategoriesResponse =
          await htodosRepository.deleteCategory(event.id, event.taskIds);
      emit(HTodosLoadCategoriesSuccess(
        allCategories: hCategoriesResponse,
      ));
    } catch (e) {
      print(e);
      emit(HTodosLoadFailure(error: e.toString()));
    }
  }

  FutureOr<void> onAddItem(
    TodosAddItem event,
    Emitter<TodosState> emit,
  ) async {
    emit(HTodosLoadInprogress());

    try {
      final hCategoriesResponse = await htodosRepository.fetchAllHCategories();
      final hTodosResponse = await htodosRepository.addIHtask(event.item);
      emit(HTodosLoadAllSuccess(
        allHTodos: hTodosResponse,
        allCategories: hCategoriesResponse,
      ));
    } catch (e) {
      print(e);
      emit(HTodosLoadFailure(error: e.toString()));
    }
  }

  FutureOr<void> onEditItem(
    TodosEditItem event,
    Emitter<TodosState> emit,
  ) async {
    emit(HTodosLoadInprogress());

    try {
      final hCategoriesResponse = await htodosRepository.fetchAllHCategories();
      final hTodosResponse = await htodosRepository.editHTask(event.item);
      emit(HTodosLoadAllSuccess(
        allHTodos: hTodosResponse,
        allCategories: hCategoriesResponse,
      ));
    } catch (e) {
      emit(HTodosLoadFailure(error: e.toString()));
    }
  }

  FutureOr<void> onDeleteItem(
    TodosDeleteItem event,
    Emitter<TodosState> emit,
  ) async {
    emit(HTodosLoadInprogress());

    try {
      final hCategoriesResponse = await htodosRepository.fetchAllHCategories();
      final hTodosResponse =
          await htodosRepository.deleteHTask(event.id, event.categoryId);
      emit(HTodosLoadAllSuccess(
        allHTodos: hTodosResponse,
        allCategories: hCategoriesResponse,
      ));
    } catch (e) {
      print(e);
      emit(HTodosLoadFailure(error: e.toString()));
    }
  }

  FutureOr<void> onToggleItemCompleteStatus(
    TodosToggleComplete event,
    Emitter<TodosState> emit,
  ) async {
    emit(HTodosLoadInprogress());

    try {
      final hCategoriesResponse = await htodosRepository.fetchAllHCategories();
      final hTodosResponse = await htodosRepository.toggleHTaskCompleteStatus(
        event.id,
        event.status,
      );
      emit(
        HTodosLoadAllSuccess(
          allHTodos: hTodosResponse,
          allCategories: hCategoriesResponse,
        ),
      );
    } catch (e) {
      print(e);
      emit(HTodosLoadFailure(error: e.toString()));
    }
  }
}
