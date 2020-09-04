import 'package:provider/provider.dart';
import 'package:re_splash/utils/open_link.dart';
import 'package:share/share.dart';
import 'package:flutter/material.dart';

import 'package:re_splash/models/collection.model.dart';
import 'package:re_splash/models/photo.model.dart';
import 'package:re_splash/widgets/item_list.dart';
import 'package:re_splash/widgets/photo_item.dart';

import '../providers/collection_details.provider.dart';

enum _PopupMenuValue { share }

class CollectionDetailsContent extends StatelessWidget {
  final Collection _collection;

  CollectionDetailsContent({@required Collection collection})
      : _collection = collection;

  void _openInBrowser(BuildContext context) async {
    final url = _collection.links.html;

    openLink(context, url);
  }

  void _handleShare() {
    Share.share(_collection.links.html);
  }

  void _handlePopupMenuSelected(_PopupMenuValue value) {
    if (value == _PopupMenuValue.share) {
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
          _collection.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            tooltip: 'Open in browser',
            onPressed: () => _openInBrowser(context),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Menu',
            onSelected: _handlePopupMenuSelected,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _PopupMenuValue.share,
                child: Row(
                  children: const [
                    Icon(Icons.share),
                    SizedBox(width: 30),
                    Text('Share'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
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
                    if (_collection.description != null)
                      Text(
                        _collection.description,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(height: 1.4),
                      ),
                    SizedBox(height: 6),
                    Text(
                      '${_collection.totalPhotos} photos - Curated by ${_collection.user.name}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
