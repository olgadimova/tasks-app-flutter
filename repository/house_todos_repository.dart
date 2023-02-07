import 'package:selvie/bloc/house_bloc/house_todos_bloc/model/house_todo_category.dart';
import 'package:selvie/bloc/house_bloc/house_todos_bloc/model/house_todo_model.dart';
import 'package:selvie/bloc/house_bloc/house_todos_bloc/repository/house_todos_provider.dart';

class HTodosRepository {
  late final HTodosDataProvider todosDataProvider = HTodosDataProvider();

  // -- local state -- //
  Map<String, HouseTodoCategory> allCatsObj = {};
  Map<String, HouseTodo> allHTasksObj = {};
  // -- local state -- //

  // h tasks //
  Future<Map<String, HouseTodo>> fetchAllHTasks() async {
    var data = await todosDataProvider.getHTasks();

    data.forEach((Map<String, dynamic> task) {
      allHTasksObj[task['id']] = HouseTodo(
        id: task['id'],
        title: task['title'],
        categoryId: task['categoryId'],
        categoryTitle: task['categoryTitle'],
        isCompleted: task['isCompleted'] == 1,
        showOnMain: task['showOnMain'] == 1,
        createdAt: task['createdAt'],
        summary: task['summary'],
      );
    });

    return allHTasksObj;
  }

  Future<Map<String, HouseTodo>> addIHtask(HouseTodo item) async {
    var newItemId = await todosDataProvider.addItemData(item);

    if (newItemId > 0) {
      allHTasksObj[newItemId] = HouseTodo(
        id: newItemId,
        title: item.title,
        categoryId: item.categoryId,
        categoryTitle: item.categoryTitle,
        summary: item.summary,
        createdAt: item.createdAt,
        isCompleted: item.isCompleted,
        showOnMain: item.showOnMain,
      );

      await fetchAllHCategories();
      allCatsObj[item.categoryId]!.tasksNum++;
      allCatsObj[item.categoryId]!.taskIds.add(newItemId);
    }

    return allHTasksObj;
  }

  Future<Map<String, HouseTodo>> editHTask(HouseTodo item) async {
    var updated = await todosDataProvider.editItemData(item);

    if (updated) {
      HouseTodo el = allHTasksObj[item.id]!;

      if (el.categoryId != item.categoryId) {
        await fetchAllHCategories();

        // find and remove old id
        allCatsObj[el.categoryId]!.tasksNum--;
        allCatsObj[el.categoryId]!
            .taskIds
            .removeWhere((element) => element == item.id);
        // add to new cat id
        allCatsObj[item.categoryId]!.tasksNum++;
        allCatsObj[el.categoryId]!.taskIds.add(item.id);
      }

      el.title = item.title;
      el.categoryId = item.categoryId;
      el.categoryTitle = item.categoryTitle;
      el.summary = item.summary;
      el.createdAt = item.createdAt;
      el.isCompleted = item.isCompleted;
    }

    return allHTasksObj;
  }

  Future<Map<String, HouseTodo>> deleteHTask(int id, int categoryId) async {
    var updated = await todosDataProvider.deleteItemData(id, categoryId);

    if (updated) {
      allHTasksObj.remove(id);

      await fetchAllHCategories();
      // find and remove old id
      allCatsObj[categoryId]!.tasksNum--;
      allCatsObj[categoryId]!.taskIds.removeWhere((el) => el == id);
    }

    return allHTasksObj;
  }

  Future<Map<String, HouseTodo>> toggleHTaskCompleteStatus(
    int id,
    bool status,
  ) async {
    final updated =
        await todosDataProvider.toggleItemCompleteStatus(id, status);

    if (updated) allHTasksObj[id]!.isCompleted = status;

    return allHTasksObj;
  }
  // -- h tasks -- //

  // h categories //
  Future<Map<String, HouseTodoCategory>> fetchAllHCategories() async {
    var data = await todosDataProvider.getHTCategories();

    data.forEach((Map<String, dynamic> c) {
      allCatsObj[c['id']] = HouseTodoCategory(
        id: c['id'],
        title: c['title'],
        tasksNum: c['tasksNum'],
        showOnMain: c['showOnMain'] == 1,
        taskIds: c['taskIds'].split(','),
      );
    });

    return allCatsObj;
  }

  Future<Map<String, HouseTodoCategory>> addCategory(
      HouseTodoCategory item) async {
    var newItemId = await todosDataProvider.addHTCategory(item);

    if (newItemId > 0) {
      allCatsObj[newItemId] = HouseTodoCategory(
        id: newItemId,
        title: item.title,
        tasksNum: item.tasksNum,
        showOnMain: item.showOnMain,
        taskIds: item.taskIds,
      );
    }

    return allCatsObj;
  }

  Future<Map<String, HouseTodoCategory>> editCategory(
      HouseTodoCategory item) async {
    var updated = await todosDataProvider.editHTCategory(item);

    if (updated) allCatsObj[item.id!] = item;

    return allCatsObj;
  }

  Future<Map<String, HouseTodoCategory>> deleteCategory(
      int id, List<String> taskIds) async {
    var deleted = await todosDataProvider.deleteHTCategory(id, taskIds);

    if (deleted) {
      allCatsObj.remove(id);
      if (taskIds.length >= 1) {
        taskIds.forEach((idString) {
          HouseTodo item = allHTasksObj[idString]!;
          item.categoryId = 1;
          item.categoryTitle = 'Uncategorized';
        });
      }
    }

    return allCatsObj;
  }
  // -- h categories -- //
}
