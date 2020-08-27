import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:re_splash/models/collection.model.dart';
import 'package:re_splash/models/photo.model.dart';
import 'package:re_splash/widgets/item_list.dart';
import 'package:re_splash/widgets/photo_item.dart';

import '../providers/collection_details.provider.dart';

enum PopupMenuValue { share }

class CollectionDetailsContent extends StatelessWidget {
  final Collection collection;

  CollectionDetailsContent({this.collection});

  void _openInBrowser() async {
    final url = collection.links.html;

    if (await canLaunch(url)) {
      await launch(url);
    } else {}
  }

  void _handleShare() {
    Share.share(collection.links.html);
  }

  void _handlePopupMenuSelected(PopupMenuValue value) {
    if (value == PopupMenuValue.share) {
      _handleShare();
    }
  }

  Widget _renderPhotoItem({Photo item, double width}) =>
      PhotoItem(photo: item, width: width);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        iconTheme: Theme.of(context).iconTheme,
        centerTitle: false,
        title: Text(
          collection.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            tooltip: 'Open in browser',
            onPressed: _openInBrowser,
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Menu',
            onSelected: _handlePopupMenuSelected,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: PopupMenuValue.share,
                  child: Row(
                    children: const [
                      Icon(Icons.share),
                      SizedBox(
                        width: 30,
                      ),
                      Text('Share'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
        // bottom: false,
        child: Column(
          children: [
            Expanded(
              child: Consumer<CollectionDetailsProvider>(
                builder: (context, value, _) => ItemList<Photo>(
                  items: value.photos,
                  loadMore: value.loadMorePhotos,
                  canLoadMore: value.canLoadMore,
                  isLoading: value.isLoading,
                  renderItem: _renderPhotoItem,
                  header: Column(
                    children: [
                      if (collection.description != null)
                        Text(
                          collection.description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${collection.totalPhotos} photos - Curated by ${collection.user.name}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(
                        height: 6,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
