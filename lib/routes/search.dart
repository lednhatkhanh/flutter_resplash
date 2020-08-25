import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:re_splash/widgets/photo_list.dart';
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

      final List<Photo> photos = await _photoService.searchPhotos(
        query: _searchInputController.text,
        page: 1,
        perPage: PER_PAGE,
      );
      final bool canLoadMore = photos.length == PER_PAGE;

      setState(() {
        _photos = photos;
        _isLoading = false;
        _canLoadMore = canLoadMore;
      });
    } catch (_) {}
  }

  Future<void> _loadMorePhotos() async {
    try {
      final int nextPage = (_photos.length / PER_PAGE).round() + 1;
      setState(() {
        _isLoading = true;
      });

      final List<Photo> photos = await _photoService.searchPhotos(
        query: _searchInputController.text,
        page: nextPage,
        perPage: PER_PAGE,
      );
      final bool canLoadMore = photos.length == PER_PAGE;

      setState(() {
        _photos.addAll(photos);
        _isLoading = false;
        _canLoadMore = canLoadMore;
      });
    } catch (_) {}
  }

  void _handleSearch(_) async {
    _searchPhotos();
  }

  void _handleLoadMore() {
    _loadMorePhotos();
  }

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
          elevation: 0,
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
                  child: PhotoList(
                    photos: _photos,
                    loadMore: _handleLoadMore,
                    canLoadMore: _canLoadMore,
                    isLoading: _isLoading,
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
