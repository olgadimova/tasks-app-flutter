import 'package:selvie/bloc/house_bloc/house_todos_bloc/model/house_todo_category.dart';
import 'package:selvie/bloc/house_bloc/house_todos_bloc/model/house_todo_model.dart';
import 'package:selvie/services/db_service.dart';

class HTodosDataProvider {
  // h tasks //
  Future<List<Map<String, dynamic>>> getHTasks() async {
    List<Map<String, dynamic>> htasks = await DBService.fetchData(
      'house_tasks',
    );
    return htasks;
  }

  Future<int> addItemData(HouseTodo item) async {
    var newItemId = await DBService.insert('house_tasks', {
      'title': item.title,
      'categoryId': item.categoryId,
      'categoryTitle': item.categoryTitle,
      'showOnMain': item.showOnMain ? 1 : 0,
      'summary': item.summary,
      'isCompleted': item.isCompleted ? 1 : 0,
    });

    var status = await DBService.updateSingleByIdAdd(
      'houset_categories',
      item.categoryId,
      'tasksNum',
      'taskIds',
      newItemId,
    );

    return newItemId;
  }

  Future<bool> editItemData(HouseTodo item) async {
    var oldItemData = await DBService.getDataByColValue(
      'house_tasks',
      'id',
      item.id!,
    );

    if (oldItemData[0]['categoryId'] != item.categoryId) {
      await DBService.updateTaskCategoryInfoEdit(
        'houset_categories',
        item.id!,
        item.categoryId,
        oldItemData[0]['categoryId'],
      );
    }

    var updateStatus = await DBService.update(
      'house_tasks',
      {
        'title': item.title,
        'categoryId': item.categoryId,
        'categoryTitle': item.categoryTitle,
        'showOnMain': item.showOnMain ? 1 : 0,
        'summary': item.summary,
        'isCompleted': item.isCompleted ? 1 : 0,
      },
      item.id!,
    );

    return updateStatus == 1;
  }

  Future<bool> deleteItemData(int id, int categoryId) async {
    var updateStatus = await DBService.delete('house_tasks', id);

    var status = await DBService.updateSingleByIdRemove(
      'houset_categories',
      categoryId,
      'tasksNum',
      'taskIds',
      id,
    );

    return updateStatus == 1;
  }

  Future<bool> toggleItemCompleteStatus(int id, bool status) async {
    var updateStatus = await DBService.updateSingleById(
      'house_tasks',
      id,
      'isCompleted',
      status ? 1 : 0,
    );

    return updateStatus == 1;
  }
  // -- h tasks -- //

  // h categories //
  Future<List<Map<String, dynamic>>> getHTCategories() async {
    List<Map<String, dynamic>> htCats = await DBService.fetchData(
      'houset_categories',
    );
    return htCats;
  }

  Future<int> addHTCategory(HouseTodoCategory item) async {
    var newItemId = await DBService.insert('houset_categories', {
      'title': item.title,
      'tasksNum': item.tasksNum,
      'showOnMain': item.showOnMain ? 1 : 0,
      'taskIds': item.taskIds.join(','),
    });

    return newItemId;
  }

  Future<bool> editHTCategory(HouseTodoCategory item) async {
    var updateStatus = await DBService.update(
      'houset_categories',
      {
        'title': item.title,
        'tasksNum': item.tasksNum,
        'showOnMain': item.showOnMain ? 1 : 0,
        'taskIds': item.taskIds.join(','),
      },
      item.id!,
    );

    final taskUpdateStatus = await DBService.updateHTaskByCategoryId(
      'house_tasks',
      item.id!,
      'categoryId',
      'categoryTitle',
      item.title,
    );

    return updateStatus == 1;
  }

  Future<bool> deleteHTCategory(int id, List<String> taskIds) async {
    var updateStatus = await DBService.delete('houset_categories', id);

    // move all tasks to uncategorised id & title
    final eventUpdateStatus = await DBService.updateHTaskCategoryDelete(
      'house_tasks',
      id,
    );

    // update uncategorized taskIds & task num
    final categoryEventsIdsUpdateStatus =
        await DBService.updateCategoryTaskIdsDelete(
      'houset_categories',
      1,
      taskIds,
    );

    return updateStatus == 1;
  }
  // -- h categories -- //
}
