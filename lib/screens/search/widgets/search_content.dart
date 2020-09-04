import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:re_splash/models/collection.model.dart';
import 'package:re_splash/screens/search/providers/query.provider.dart';
import 'package:re_splash/screens/search/providers/search_collections.provider.dart';
import 'package:re_splash/screens/search/providers/search_photos.provider.dart';
import 'package:re_splash/screens/search/widgets/search_photos_filter_button.dart';
import 'package:re_splash/widgets/item_list.dart';
import 'package:re_splash/models/photo.model.dart';

class SearchContent extends StatefulWidget {
  @override
  _SearchContentState createState() => _SearchContentState();
}

const _tabs = ['Photos', 'Collections'];

class _SearchContentState extends State<SearchContent>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchInputController = TextEditingController();
  QueryProvider _queryProvider;
  SearchPhotosProvider _searchPhotosProvider;
  SearchCollectionsProvider _searchCollectionsProvider;
  bool _showClearButton;
  bool _autoFocusSearchInput;
  TabController _tabController;
  String _currentTab;

  @override
  void initState() {
    super.initState();

    _showClearButton = false;
    _queryProvider = Provider.of<QueryProvider>(context, listen: false);
    _searchPhotosProvider =
        Provider.of<SearchPhotosProvider>(context, listen: false);
    _searchCollectionsProvider =
        Provider.of<SearchCollectionsProvider>(context, listen: false);

    _searchInputController.addListener(_handleToggleClearButton);
    if (_queryProvider.query?.isNotEmpty == true) {
      _searchInputController.text = _queryProvider.query;
      _autoFocusSearchInput = false;
    } else {
      _autoFocusSearchInput = true;
    }

    _tabController = TabController(length: 2, vsync: this);
    _currentTab = _tabs[0];
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    super.dispose();
    _searchInputController.removeListener(_handleToggleClearButton);
    _searchInputController.dispose();

    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
  }

  void _handleTabChange() {
    setState(() {
      _currentTab = _tabs[_tabController.index];
    });
  }

  void _handleToggleClearButton() {
    setState(() {
      _showClearButton = _searchInputController.text?.isNotEmpty == true;
    });
  }

  void _handleSearch(_) {
    _queryProvider.query = _searchInputController.text;

    _searchPhotosProvider.searchPhotos();
    _searchCollectionsProvider.searchCollections();
  }

  void _handleClearSearch() {
    _searchInputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final emptyListWidget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/undraw_location_search.png',
          width: 200,
        ),
        Text(
          'Nothing to see here...',
          style: Theme.of(context).textTheme.bodyText1.copyWith(height: 1.5),
        ),
        Text(
          'Try to search for something',
          style: Theme.of(context).textTheme.bodyText2.copyWith(height: 1.5),
        ),
      ],
    );

    return Consumer2<SearchPhotosProvider, SearchCollectionsProvider>(
      builder: (
        context,
        searchPhotosProvider,
        searchCollectionProvider,
        _,
      ) =>
          Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          iconTheme: Theme.of(context).iconTheme,
          centerTitle: false,
          title: TextField(
            autofocus: _autoFocusSearchInput,
            controller: _searchInputController,
            decoration: InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
              suffixIcon: _showClearButton
                  ? IconButton(
                      icon: Icon(Icons.clear, size: 18),
                      onPressed: _handleClearSearch)
                  : null,
            ),
            onSubmitted: _handleSearch,
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: _tabs
                .map(
                  (e) => Tab(
                    child: Text(
                      e,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Column(
              children: [
                Expanded(
                  child: ItemList<Photo>(
                    items: searchPhotosProvider.photos,
                    loadMore: searchPhotosProvider.loadMorePhotos,
                    canLoadMore: searchPhotosProvider.canLoadMore,
                    isLoading: searchPhotosProvider.isLoading,
                    empty: emptyListWidget,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Expanded(
                  child: ItemList<Collection>(
                    items: searchCollectionProvider.collections,
                    loadMore: searchCollectionProvider.loadMoreCollections,
                    canLoadMore: searchCollectionProvider.canLoadMore,
                    isLoading: searchCollectionProvider.isLoading,
                    empty: emptyListWidget,
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            _currentTab == 'Photos' && searchPhotosProvider.photos.isNotEmpty
                ? SearchPhotosFilterButton()
                : null,
      ),
    );
  }
}
