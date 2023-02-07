import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:selvie/bloc/house_bloc/house_todos_bloc/model/house_todo_category.dart';
import 'package:selvie/bloc/house_bloc/house_todos_bloc/model/house_todo_model.dart';
import 'package:selvie/bloc/house_bloc/house_todos_bloc/screens/htask_add.dart';
import 'package:selvie/bloc/house_bloc/house_todos_bloc/screens/htasks_categories.dart';
import 'package:selvie/bloc/house_bloc/house_todos_bloc/screens/htasks_list_wrapper.dart';
import 'package:selvie/theme/style.dart';

void main() {
  Widget makeTesteableWidget({required Widget child}) {
    return MaterialApp(
      theme: appThemeLight(),
      darkTheme: appThemeDark(),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('ru', ''),
      ],
      home: child,
    );
  }

  testWidgets('House tasks list renders with empty state if no tasks found',
      (WidgetTester tester) async {
    final widget = makeTesteableWidget(
      child: Material(
        child: HTasksListWrapper(
          searchQuery: '',
          tasks: [],
          tasksCategories: {
            '1': HouseTodoCategory(
              id: 1,
              title: 'Uncategorized',
              tasksNum: 0,
              showOnMain: false,
              taskIds: [],
            ),
          },
          currentPageIndex: 0,
          onLoad: () {},
        ),
      ),
    );

    await tester.pumpWidget(widget);

    expect(find.byIcon(Icons.add_task), findsNWidgets(2));
    expect(find.text('Your House Tasks List Is Empty.'), findsOneWidget);
    expect(
      find.text('Add Your First Category and House Task.'),
      findsOneWidget,
    );
  });

  testWidgets(
      'House tasks list renders category and task tiles if tasks length > 0',
      (WidgetTester tester) async {
    final widget = makeTesteableWidget(
      child: Material(
        child: HTasksListWrapper(
          searchQuery: '',
          onLoad: () {},
          tasks: [
            HouseTodo(
                id: 1,
                title: 'Wash dishes',
                summary: '',
                isCompleted: false,
                categoryId: 1,
                categoryTitle: 'Uncategorized',
                showOnMain: false),
          ],
          tasksCategories: {
            '1': HouseTodoCategory(
              id: 1,
              title: 'Uncategorized',
              tasksNum: 1,
              showOnMain: false,
              taskIds: [],
            ),
          },
          currentPageIndex: 0,
        ),
      ),
    );

    await tester.pumpWidget(widget);

    expect(find.byIcon(Icons.add_task), findsOneWidget);
    expect(find.text('Your House Tasks List Is Empty.'), findsNothing);
    expect(find.text('Add Your First Category and House Task.'), findsNothing);

    expect(find.byKey(Key('house-tasks-wrapper')), findsOneWidget);
    expect(find.text('Uncategorized'), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_border_rounded), findsOneWidget);
    expect(find.text('Wash dishes'), findsOneWidget);
    expect(
        find.widgetWithIcon(ListTile, Icons.more_vert_rounded), findsOneWidget);
    expect(find.widgetWithIcon(ListTile, Icons.check_circle_outline_rounded),
        findsOneWidget);
  });

  testWidgets('Click Add/Edit Site button goes to Tasks Categories page',
      (WidgetTester tester) async {
    final widget = makeTesteableWidget(
      child: Material(
        child: HTasksListWrapper(
          searchQuery: '',
          tasks: [],
          onLoad: () {},
          tasksCategories: {
            '1': HouseTodoCategory(
              id: 1,
              title: 'Uncategorized',
              tasksNum: 0,
              showOnMain: false,
              taskIds: [],
            ),
          },
          currentPageIndex: 0,
        ),
      ),
    );

    await tester.pumpWidget(widget);

    expect(find.text('Add/Edit Site'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(find.text('Add/Edit Site'));
    await tester.pumpAndSettle(Duration(microseconds: 300));

    expect(find.byType(HouseCategories), findsOneWidget);
  });

  testWidgets('Click Add Task list header button goes to Add task page',
      (WidgetTester tester) async {
    final widget = makeTesteableWidget(
      child: Material(
        child: HTasksListWrapper(
          searchQuery: '',
          tasks: [],
          onLoad: () {},
          tasksCategories: {
            '1': HouseTodoCategory(
              id: 1,
              title: 'Uncategorized',
              tasksNum: 0,
              showOnMain: false,
              taskIds: [],
            ),
          },
          currentPageIndex: 0,
        ),
      ),
    );

    await tester.pumpWidget(widget);

    expect(find.byIcon(Icons.add_task), findsNWidgets(2));

    await tester.tap(find.byIcon(Icons.add_task).first);
    await tester.pumpAndSettle(Duration(microseconds: 300));

    expect(find.byType(HouseTaskAddModal), findsOneWidget);
  });

  testWidgets('Click Add Task empty state button goes to Add task page',
      (WidgetTester tester) async {
    final widget = makeTesteableWidget(
      child: Material(
        child: HTasksListWrapper(
          searchQuery: '',
          onLoad: () {},
          tasks: [],
          tasksCategories: {
            '1': HouseTodoCategory(
              id: 1,
              title: 'Uncategorized',
              tasksNum: 0,
              showOnMain: false,
              taskIds: [],
            ),
          },
          currentPageIndex: 0,
        ),
      ),
    );

    await tester.pumpWidget(widget);

    expect(find.byIcon(Icons.add_task), findsNWidgets(2));

    await tester.tap(find.byIcon(Icons.add_task).last);
    await tester.pumpAndSettle(Duration(microseconds: 300));

    expect(find.byType(HouseTaskAddModal), findsOneWidget);
  });
}
