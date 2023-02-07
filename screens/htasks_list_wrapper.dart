import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:selvie/bloc/house_bloc/house_todos_bloc/model/house_todo_category.dart';
import 'package:selvie/bloc/house_bloc/house_todos_bloc/model/house_todo_model.dart';
import 'package:selvie/bloc/house_bloc/house_todos_bloc/screens/components/htasks_list_header.dart';
import 'package:selvie/bloc/house_bloc/house_todos_bloc/screens/htasks_list.dart';
import 'package:selvie/bloc/house_bloc/house_todos_bloc/todos_bloc.dart';

class HTasksListWrapper extends StatefulWidget {
  const HTasksListWrapper({
    Key? key,
    this.searchQuery,
    required this.tasks,
    required this.tasksCategories,
    required this.currentPageIndex,
    required this.onLoad,
  }) : super(key: key);

  final String? searchQuery;
  final List<HouseTodo> tasks;
  final Map<String, HouseTodoCategory> tasksCategories;
  final int currentPageIndex;
  final Function onLoad;

  @override
  State<HTasksListWrapper> createState() => _HTasksListWrapperState();
}

class _HTasksListWrapperState extends State<HTasksListWrapper> {
  List<HouseTodo> _tasks = [];
  List<HouseTodo> _tasksFiltered = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _tasks = widget.tasks;
      _tasksFiltered = widget.tasks;
    });
  }

  void setFilteredTasks() {
    setState(() {
      _tasksFiltered = _tasks;
    });
  }

  void handleSearch() {
    if (widget.searchQuery != '' && widget.currentPageIndex == 0) {
      setState(() {
        _tasksFiltered = _tasks
            .where((el) =>
                el.title.toLowerCase().contains(widget.searchQuery!) ||
                el.summary.toLowerCase().contains(widget.searchQuery!))
            .toList();
      });
    } else if (widget.searchQuery == '' && widget.currentPageIndex == 0) {
      setState(() {
        _tasksFiltered = _tasks;
      });
    }
  }

  void onAddTask(
    String title,
    int categoryId,
    String categoryTitle,
    String extraNotes,
    BuildContext ctx,
  ) {
    BlocProvider.of<TodosBloc>(ctx).add(
      TodosAddItem(
        HouseTodo(
          title: title,
          categoryId: categoryId,
          categoryTitle: categoryTitle,
          isCompleted: false,
          summary: extraNotes,
          showOnMain: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    handleSearch();
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Stack(
        children: [
          HouseTasksList(
            searchQuery: widget.searchQuery!,
            categories: widget.tasksCategories,
            tasks: _tasksFiltered,
            handleAddTask: (
              String title,
              int categoryId,
              String categoryTitile,
              String extraNotes,
              BuildContext ctx,
            ) {
              onAddTask(
                title,
                categoryId,
                categoryTitile,
                extraNotes,
                ctx,
              );
            },
            onLoad: (BuildContext ctx) {
              widget.onLoad(ctx);
            },
          ),
          // header (add category + add task buttons)
          HTasksListHeader(
            onAddTask: (
              String title,
              int categoryId,
              String categoryTitle,
              String extraNotes,
              BuildContext ctx,
            ) {
              onAddTask(
                title,
                categoryId,
                categoryTitle,
                extraNotes,
                ctx,
              );
            },
            onLoad: (BuildContext ctx) {
              BlocProvider.of<TodosBloc>(ctx).add(TodosFetchAll());
            },
          )
        ],
      ),
    );
  }
}
