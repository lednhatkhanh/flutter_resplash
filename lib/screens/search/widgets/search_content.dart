import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:re_splash/models/collection.model.dart';
import 'package:re_splash/screens/search/providers/query.provider.dart';
import 'package:re_splash/screens/search/providers/search_collections.provider.dart';
import 'package:re_splash/screens/search/providers/search_photos.provider.dart';
import 'package:re_splash/widgets/collection_item.dart';
import 'package:re_splash/widgets/photo_item.dart';
import 'package:re_splash/widgets/item_list.dart';
import 'package:re_splash/models/photo.model.dart';

class SearchContent extends StatefulWidget {
  @override
  _SearchContentState createState() => _SearchContentState();
}

class _SearchContentState extends State<SearchContent> {
  final TextEditingController _searchInputController = TextEditingController();
  QueryProvider _queryProvider;
  SearchPhotosProvider _searchPhotosProvider;
  SearchCollectionsProvider _searchCollectionsProvider;

  @override
  void initState() {
    super.initState();

    _queryProvider = Provider.of<QueryProvider>(context, listen: false);
    _searchPhotosProvider =
        Provider.of<SearchPhotosProvider>(context, listen: false);
    _searchCollectionsProvider =
        Provider.of<SearchCollectionsProvider>(context, listen: false);
  }

  void _handleSearch(_) {
    _queryProvider.query = _searchInputController.text;

    _searchPhotosProvider.searchPhotos();
    _searchCollectionsProvider.searchCollections();
  }

  void _handleClearSearch() {
    _searchInputController.clear();
  }

  Widget _renderPhotoItem({Photo item, double width}) =>
      PhotoItem(photo: item, width: width);

  Widget _renderCollectionItem({Collection item, double width}) =>
      CollectionItem(
        collection: item,
        width: width,
      );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          iconTheme: Theme.of(context).iconTheme,
          centerTitle: false,
          title: TextField(
            autofocus: true,
            controller: _searchInputController,
            decoration: InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
              suffixIcon: IconButton(icon: Icon(Icons.clear, size: 18), onPressed: _handleClearSearch),
            ),
            onSubmitted: _handleSearch,
          ),
          bottom: TabBar(tabs: [
            Tab(
              child: Text(
                'Photos',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Tab(
              child: Text(
                'Collections',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Tab(
              child: Text(
                'Users',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ]),
        ),
        body: Consumer3<QueryProvider, SearchPhotosProvider,
            SearchCollectionsProvider>(
          builder: (
            context,
            _,
            searchPhotosProvider,
            searchCollectionProvider,
            __,
          ) =>
              TabBarView(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ItemList<Photo>(
                      items: searchPhotosProvider.photos,
                      loadMore: searchPhotosProvider.loadMorePhotos,
                      canLoadMore: searchPhotosProvider.canLoadMore,
                      isLoading: searchPhotosProvider.isLoading,
                      renderItem: _renderPhotoItem,
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
                      renderItem: _renderCollectionItem,
                    ),
                  ),
                ],
              ),
              Text('Users'),
            ],
          ),
        ),
      ),
    );
  }
}
