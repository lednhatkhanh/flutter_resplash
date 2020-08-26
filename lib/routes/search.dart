import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:re_splash/widgets/photo_item.dart';
import 'package:re_splash/widgets/item_list.dart';
import 'package:re_splash/services/photos.service.dart';
import 'package:re_splash/models/photo.model.dart';

class SearchRoute extends StatefulWidget {
  @override
  _SearchRouteState createState() => _SearchRouteState();
}

const int PER_PAGE = 15;

class _SearchRouteState extends State<SearchRoute> {
  final PhotosService _photoService = PhotosService();
  final TextEditingController _searchInputController = TextEditingController();

  bool _canLoadMore;
  List<Photo> _photos;
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _photos = [];
    _canLoadMore = true;
    _isLoading = false;
  }

  Future<void> _searchPhotos() async {
    try {
      setState(() {
        _isLoading = true;
        _photos = [];
      });

      final photos = await _photoService.searchPhotos(
        query: _searchInputController.text,
        page: 1,
        perPage: PER_PAGE,
      );
      final canLoadMore = photos.length == PER_PAGE;

      setState(() {
        _photos = photos;
        _isLoading = false;
        _canLoadMore = canLoadMore;
      });
    } catch (_) {}
  }

  Future<void> _loadMorePhotos() async {
    try {
      final nextPage = (_photos.length / PER_PAGE).round() + 1;
      setState(() {
        _isLoading = true;
      });

      final photos = await _photoService.searchPhotos(
        query: _searchInputController.text,
        page: nextPage,
        perPage: PER_PAGE,
      );
      final canLoadMore = photos.length == PER_PAGE;

      setState(() {
        _photos.addAll(photos);
        _isLoading = false;
        _canLoadMore = canLoadMore;
      });
    } catch (_) {}
  }

  void _handleSearch(_) {
    _searchPhotos();
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
            child: Column(
              children: [
                Expanded(
                  child: ItemList<Photo>(
                    items: _photos,
                    loadMore: _loadMorePhotos,
                    canLoadMore: _canLoadMore,
                    isLoading: _isLoading,
                    renderItem: _renderPhotoItem,
                  ),
                ),
              ],
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
