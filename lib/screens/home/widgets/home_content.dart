import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_splash/models/collection.model.dart';
import 'package:re_splash/data/collections.data.dart';
import 'package:re_splash/widgets/item_list.dart';
import 'package:re_splash/models/photo.model.dart';
import 'package:re_splash/data/photos.data.dart';
import 'package:re_splash/screens/search/search.screen.dart';

import '../providers/home.provider.dart';
import 'collections_type_modal.dart';
import 'photos_order_by_modal.dart';

class HomeContent extends StatefulWidget {
  HomeContent({Key key}) : super(key: key);

  @override
  _HomeContentState createState() => _HomeContentState();
}

const int perPage = 15;

class _HomeContentState extends State<HomeContent>
    with SingleTickerProviderStateMixin {
  HomeProvider _homeProvider;
  TabController _tabController;
  final List<String> _tabs = ['Photos', 'Collections'];

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: _tabs.length, initialIndex: 0, vsync: this);
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _homeProvider.dispose();
  }

  void _goToSearchScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen(query: null)),
    );
  }

  void _handleOrderByChanged(PhotosOrderBy photosOrderBy) {
    _homeProvider.photosOrderBy = photosOrderBy;
    Navigator.pop(context);
  }

  void _handleCollectionsTypeChanged(CollectionsType collectionsType) {
    _homeProvider.collectionsType = collectionsType;
    Navigator.pop(context);
  }

  void _handleShowShortBottomSheet() {
    if (_tabs[_tabController.index] == 'Photos') {
      showModalBottomSheet(
        context: context,
        builder: (context) => PhotosOrderByModal(
          onChanged: _handleOrderByChanged,
          orderBy: _homeProvider.photosOrderBy,
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) => CollectionTypeModal(
          onChanged: _handleCollectionsTypeChanged,
          type: _homeProvider.collectionsType,
        ),
      );
    }
  }

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
      body: Consumer<HomeProvider>(
        builder: (context, value, _) {
          return TabBarView(
            controller: _tabController,
            children: [
              Column(
                children: [
                  // Expanded needs to be the direct child of Column, Row or Flex
                  Expanded(
                    child: ItemList<Photo>(
                      items: value.photos,
                      loadMore: value.getMorePhotos,
                      isLoading: value.isLoading,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  // Expanded needs to be the direct child of Column, Row or Flex
                  Expanded(
                    child: ItemList<Collection>(
                      isLoading: value.isLoading,
                      loadMore: value.getMoreCollections,
                      items: value.collections,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
