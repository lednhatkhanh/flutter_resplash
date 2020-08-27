import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:re_splash/screens/search/providers/query.provider.dart';
import 'package:re_splash/screens/search/providers/search_photos.provider.dart';
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

  @override
  void initState() {
    super.initState();

    _queryProvider = Provider.of<QueryProvider>(context, listen: false);
    _searchPhotosProvider =
        Provider.of<SearchPhotosProvider>(context, listen: false);
  }

  void _handleSearch(_) {
    _queryProvider.query = _searchInputController.text;

    _searchPhotosProvider.searchPhotos();
  }

  Widget _renderPhotoItem({Photo item, double width}) =>
      PhotoItem(photo: item, width: width);

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
        body: TabBarView(children: [
          SafeArea(
            bottom: false,
            child: Consumer2<QueryProvider, SearchPhotosProvider>(
              builder: (context, _, searchPhotosProvider, __) {
                return Column(
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
                );
              },
            ),
          ),
          SafeArea(
            child: Text('Collections'),
          ),
          SafeArea(
            child: Text('Users'),
          ),
        ]),
      ),
    );
  }
}
