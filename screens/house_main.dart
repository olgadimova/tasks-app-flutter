import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:selvie/bloc/house_bloc/house_groceries_bloc/groceries_bloc.dart';
import 'package:selvie/bloc/house_bloc/house_groceries_bloc/screens/groceries_list_wrapper.dart';
import 'package:selvie/bloc/house_bloc/house_todos_bloc/screens/htasks_list_wrapper.dart';
import 'package:selvie/bloc/house_bloc/house_todos_bloc/todos_bloc.dart';
import 'package:selvie/components/layout/empty_loading_container.dart';
import 'package:selvie/components/other/search_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HouseMain extends StatefulWidget {
  HouseMain({required this.initialRoute, Key? key}) : super(key: key);

  final int initialRoute;

  @override
  _HouseMainState createState() => _HouseMainState();
}

class _HouseMainState extends State<HouseMain> with TickerProviderStateMixin {
  String searchQuery = '';
  int _currentIndex = 0;
  late TabController _tabController;

  GlobalKey<FormState> searchBarformKey = GlobalKey<FormState>();
  TextEditingController contr = TextEditingController(text: '');

  void initState() {
    super.initState();
    _currentIndex = widget.initialRoute;
    _tabController = TabController(
      initialIndex: widget.initialRoute,
      length: 2,
      vsync: this,
    );

    Future.delayed(Duration.zero, () {
      fetchBlocHTasks(context);
      fetchBlocGroceries(context);
    });
  }

  void handleSearch(query) {
    setState(() {
      searchQuery = query;
    });
  }

  void fetchBlocGroceries(BuildContext ctx) {
    BlocProvider.of<GroceriesBloc>(ctx).add(GroceriesFetchAll());
  }

  void fetchBlocHTasks(BuildContext ctx) {
    BlocProvider.of<TodosBloc>(ctx).add(TodosFetchAll());
  }

  @override
  Widget build(BuildContext context) {
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
          if (searchQuery != '') searchQuery = '';
        });
        if (contr.text != '') {
          searchBarformKey.currentState!.reset();
          contr.text = '';
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.house,
          style: Theme.of(context).textTheme.headline1,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 1,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: DefaultTabController(
        length: 2,
        initialIndex: _currentIndex,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 6.0,
              ),
              child: SearchBar(
                label: _currentIndex == 0
                    ? AppLocalizations.of(context)!.searchHouseTasks
                    : AppLocalizations.of(context)!.searchHouseGroceries,
                onSearch: (String query) {
                  handleSearch(query);
                },
                errMsg: AppLocalizations.of(context)!.pleaseEnterSearchText,
                searchBarFormKey: searchBarformKey,
                controller: contr,
              ),
            ),

            // tab bar
            Container(
              height: 45,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                  ),
                  top: BorderSide(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                color: Theme.of(context).splashColor,
              ),
              child: TabBar(
                labelColor: Theme.of(context).textTheme.headline5?.color,
                indicatorColor: Theme.of(context).textTheme.headline5?.color,
                unselectedLabelColor: Colors.grey[700],
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.check_circle_outline_rounded, size: 26),
                        Text(
                          AppLocalizations.of(context)!.houseTasks,
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(CupertinoIcons.cart, size: 23),
                        Text(
                          AppLocalizations.of(context)!.groceriesList,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // tab view
            Expanded(
              child: Container(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // tasks
                    BlocBuilder<TodosBloc, TodosState>(
                      builder: (context, state) {
                        if (state is HTodosInitial)
                          return Container();
                        else if (state is HTodosLoadInprogress)
                          return EmptyLoadingContainer();
                        else if (state is HTodosLoadFailure)
                          return Center(
                            child: Text(
                              AppLocalizations.of(context)!.errorOccured,
                            ),
                          );
                        else if (state is HTodosLoadAllSuccess)
                          return HTasksListWrapper(
                            tasks: state.allHTodos.values.toList(),
                            tasksCategories: state.allCategories,
                            searchQuery: searchQuery,
                            currentPageIndex: _currentIndex,
                            onLoad: (ctx) {
                              fetchBlocHTasks(ctx);
                            },
                          );
                        else
                          return EmptyLoadingContainer();
                      },
                    ),
                    // groceries
                    BlocBuilder<GroceriesBloc, GroceriesState>(
                      builder: (context, state) {
                        if (state is GroceriesInitial)
                          return EmptyLoadingContainer();
                        else if (state is GroceriesLoadInprogress)
                          return EmptyLoadingContainer();
                        else if (state is GroceriesLoadFailure)
                          return Center(
                            child: Text(
                              AppLocalizations.of(context)!.errorOccured,
                            ),
                          );
                        else if (state is GroceriesLoadSuccess) {
                          return GroceriesListWrapper(
                            key: Key('GroceriesListWrapper'),
                            groceries: state.allGroceries.values.toList(),
                            searchQuery: searchQuery,
                            currentPageIndex: _currentIndex,
                          );
                        } else
                          return Center(
                            child: Text(
                              AppLocalizations.of(context)!.errorOccured,
                            ),
                          );
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
