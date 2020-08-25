import 'package:flutter/material.dart';
import 'package:re_splash/routes/home/oder_by_modal_content.dart';
import 'package:re_splash/widgets/photo_list.dart';
import 'package:re_splash/models/photo.model.dart';
import 'package:re_splash/services/photos.service.dart';
import 'package:re_splash/routes/search.dart';

class HomeRoute extends StatefulWidget {
  HomeRoute({Key key}) : super(key: key);

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

const int PER_PAGE = 15;

class _HomeRouteState extends State<HomeRoute> {
  final PhotosService _photoService = PhotosService();

  List<Photo> _photos;
  bool _isLoading;
  GetPhotosOrderBy _orderBy;

  @override
  void initState() {
    super.initState();
    _photos = [];
    _isLoading = false;
    _orderBy = GetPhotosOrderBy.latest;

    _getPhotos();
  }

  Future<void> _getPhotos() async {
    try {
      setState(() {
        _isLoading = true;
        _photos = [];
      });

      final List<Photo> photos = await _photoService.getPhotos(
        page: 1,
        perPage: PER_PAGE,
        orderBy: _orderBy,
      );

      setState(() {
        _photos = photos;
        _isLoading = false;
      });
    } catch (_) {}
  }

  Future<void> _getMorePhotos() async {
    try {
      final int nextPage = (_photos.length / PER_PAGE).round() + 1;

      setState(() {
        _isLoading = true;
      });

      final List<Photo> photos = await _photoService.getPhotos(
        page: nextPage,
        perPage: PER_PAGE,
        orderBy: _orderBy,
      );

      setState(() {
        _photos.addAll(photos);
        _isLoading = false;
      });
    } catch (_) {}
  }

  void _handleLoadMore() {
    _getMorePhotos();
  }

  void _goToSearchPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchRoute()),
    );
  }

  void _handleOrderByChanged(GetPhotosOrderBy value) {
    setState(() {
      _orderBy = value;
    });

    _getPhotos();
    Navigator.pop(context);
  }

  void _handleShowShortBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return OrderByModalContent(
          onChanged: _handleOrderByChanged,
          orderBy: _orderBy,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(
                tabs: [
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
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 3.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(flex: 1),
              IconButton(
                icon: const Icon(Icons.sort),
                tooltip: 'Sort',
                onPressed: _handleShowShortBottomSheet,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.search),
          onPressed: _goToSearchPage,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: TabBarView(
          children: [
            Expanded(
              child: PhotoList(
                photos: _photos,
                loadMore: _handleLoadMore,
                isLoading: _isLoading,
              ),
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}
