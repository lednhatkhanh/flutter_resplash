import 'package:flutter/material.dart';
import 'package:re_splash/models/collection.model.dart';
import 'package:re_splash/routes/home/collections_type_modal.dart';
import 'package:re_splash/routes/home/photos_order_by_modal.dart';
import 'package:re_splash/services/collections.service.dart';
import 'package:re_splash/widgets/collection_item.dart';
import 'package:re_splash/widgets/photo_item.dart';
import 'package:re_splash/widgets/item_list.dart';
import 'package:re_splash/models/photo.model.dart';
import 'package:re_splash/services/photos.service.dart';
import 'package:re_splash/routes/search.dart';

class HomeRoute extends StatefulWidget {
  HomeRoute({Key key}) : super(key: key);

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

const int perPage = 15;

class _HomeRouteState extends State<HomeRoute>
    with SingleTickerProviderStateMixin {
  final PhotosService _photoService = PhotosService();
  final CollectionsService _collectionsService = CollectionsService();
  TabController _tabController;
  final List<String> _tabs = ['Photos', 'Collections'];

  bool _isLoading;

  List<Collection> _collections;
  CollectionsType _collectionsType;

  List<Photo> _photos;
  PhotosOrderBy _photosOrderBy;

  @override
  void initState() {
    super.initState();
    _collections = [];
    _photos = [];
    _isLoading = false;
    _photosOrderBy = PhotosOrderBy.latest;
    _collectionsType = CollectionsType.all;
    _tabController =
        TabController(length: _tabs.length, initialIndex: 0, vsync: this);

    _getPhotos();
    _getCollections();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future<void> _getPhotos() async {
    try {
      setState(() {
        _isLoading = true;
        _photos = [];
      });

      final photos = await _photoService.listPhotos(
        page: 1,
        perPage: perPage,
        orderBy: _photosOrderBy,
      );

      setState(() {
        _photos = photos;
        _isLoading = false;
      });
    } catch (_) {}
  }

  Future<void> _getMorePhotos() async {
    try {
      final nextPage = (_photos.length / perPage).round() + 1;

      setState(() {
        _isLoading = true;
      });

      final photos = await _photoService.listPhotos(
        page: nextPage,
        perPage: perPage,
        orderBy: _photosOrderBy,
      );

      setState(() {
        _photos.addAll(photos);
        _isLoading = false;
      });
    } catch (_) {}
  }

  Future<void> _getCollections() async {
    try {
      setState(() {
        _isLoading = true;
        _collections = [];
      });

      var collections = <Collection>[];
      if (_collectionsType == CollectionsType.all) {
        collections = await _collectionsService.listCollections(
          page: 1,
          perPage: perPage,
        );
      } else {
        collections = await _collectionsService.listFeaturedCollections(
          page: 1,
          perPage: perPage,
        );
      }

      setState(() {
        _collections = collections;
        _isLoading = false;
      });
    } catch (_) {}
  }

  Future<void> getMoreCollections() async {
    try {
      final nextPage = (_collections.length / perPage).round() + 1;

      setState(() {
        _isLoading = true;
      });

      var collections = <Collection>[];
      if (_collectionsType == CollectionsType.all) {
        collections = await _collectionsService.listCollections(
          page: nextPage,
          perPage: perPage,
        );
      } else {
        collections = await _collectionsService.listFeaturedCollections(
          page: nextPage,
          perPage: perPage,
        );
      }

      setState(() {
        _collections.addAll(collections);
        _isLoading = false;
      });
    } catch (_) {}
  }

  void _goToSearchScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchRoute()),
    );
  }

  void _handleOrderByChanged(PhotosOrderBy orderBy) {
    setState(() {
      _photosOrderBy = orderBy;
    });

    _getPhotos();
    Navigator.pop(context);
  }

  void _handleCollectionsTypeChanged(CollectionsType type) {
    setState(() {
      _collectionsType = type;
    });

    _getCollections();
    Navigator.pop(context);
  }

  void _handleShowShortBottomSheet() {
    if (_tabs[_tabController.index] == 'Photos') {
      showModalBottomSheet(
        context: context,
        builder: (context) => PhotosOrderByModal(
          onChanged: _handleOrderByChanged,
          orderBy: _photosOrderBy,
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) => CollectionTypeModal(
          onChanged: _handleCollectionsTypeChanged,
          type: _collectionsType,
        ),
      );
    }
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
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TabBar(
              controller: _tabController,
              tabs: _tabs
                  .map(
                    (tabText) => Tab(
                      child: Text(
                        tabText,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  )
                  .toList(),
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
              tooltip: 'Order by',
              onPressed: _handleShowShortBottomSheet,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: _goToSearchScreen,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              // Expanded needs to be the direct child of Column, Row or Flex
              Expanded(
                child: ItemList<Photo>(
                  items: _photos,
                  loadMore: _getMorePhotos,
                  isLoading: _isLoading,
                  renderItem: _renderPhotoItem,
                ),
              ),
            ],
          ),
          Column(
            children: [
              // Expanded needs to be the direct child of Column, Row or Flex
              Expanded(
                child: ItemList<Collection>(
                  isLoading: _isLoading,
                  loadMore: getMoreCollections,
                  items: _collections,
                  renderItem: _renderCollectionItem,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
