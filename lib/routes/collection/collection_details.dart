import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:re_splash/models/collection.model.dart';
import 'package:re_splash/models/photo.model.dart';
import 'package:re_splash/services/collections.service.dart';
import 'package:re_splash/widgets/item_list.dart';
import 'package:re_splash/widgets/photo_item.dart';

class CollectionDetails extends StatefulWidget {
  final Collection collection;

  CollectionDetails({this.collection});

  @override
  _CollectionDetailsState createState() => _CollectionDetailsState();
}

const int PER_PAGE = 15;

enum PopupMenuValue { share }

class _CollectionDetailsState extends State<CollectionDetails> {
  final CollectionsService _collectionsService = CollectionsService();
  List<Photo> _photos;
  bool _isLoading;
  bool _canLoadMore;

  @override
  void initState() {
    super.initState();

    _photos = [];
    _canLoadMore = true;
    _isLoading = false;

    _getPhotos();
  }

  Future<void> _getPhotos() async {
    try {
      setState(() {
        _isLoading = true;
        _photos = [];
      });

      final photos = await _collectionsService.getCollectionPhotos(
        id: widget.collection.id,
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

      final photos = await _collectionsService.getCollectionPhotos(
        id: widget.collection.id,
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

  Widget _renderPhotoItem({Photo item, double width}) =>
      PhotoItem(photo: item, width: width);

  void _openInBrowser() async {
    final url = widget.collection.links.html;

    if (await canLaunch(url)) {
      await launch(url);
    } else {}
  }

  void _handleShare() {
    Share.share(widget.collection.links.html);
  }

  void _handlePopupMenuSelected(PopupMenuValue value) {
    if (value == PopupMenuValue.share) {
      _handleShare();
    }
  }

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
          widget.collection.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.open_in_browser),
            tooltip: 'Open in browser',
            onPressed: _openInBrowser,
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            tooltip: 'Menu',
            onSelected: _handlePopupMenuSelected,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: PopupMenuValue.share,
                  child: Row(
                    children: [
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
              child: ItemList<Photo>(
                items: _photos,
                loadMore: _loadMorePhotos,
                canLoadMore: _canLoadMore,
                isLoading: _isLoading,
                renderItem: _renderPhotoItem,
                header: Column(
                  children: [
                    if (widget.collection.description != null)
                      Text(
                        widget.collection.description,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      '${widget.collection.totalPhotos} photos - Curated by ${widget.collection.user.name}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    SizedBox(
                      height: 6,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
