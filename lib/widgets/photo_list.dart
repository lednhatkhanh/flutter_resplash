import 'package:flutter/material.dart';
import 'package:re_splash/models/photo.model.dart';
import './photo_item.dart';

class PhotoList extends StatefulWidget {
  final List<Photo> photos;
  final void Function() loadMore;
  final bool canLoadMore;
  final bool isLoading;

  PhotoList({
    @required this.photos,
    @required this.loadMore,
    this.canLoadMore = true,
    @required this.isLoading,
  });

  @override
  _PhotoListState createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  final ScrollController _controller =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  @override
  void initState() {
    super.initState();

    _controller.addListener(_handleTriggerLoadmore);
  }

  @override
  void dispose() {
    super.dispose();

    _controller.removeListener(_handleTriggerLoadmore);
    _controller.dispose();
  }

  void _handleTriggerLoadmore() {
    final bool isEnd =
        _controller.offset >= _controller.position.maxScrollExtent * 0.8;
    if (isEnd &&
        widget.canLoadMore &&
        widget.photos.length > 0 &&
        !widget.isLoading) {
      widget.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = 15;

    return widget.isLoading && widget.photos.length == 0
        ? Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            controller: _controller,
            itemCount: widget.photos.length + 1,
            padding: EdgeInsets.symmetric(
                horizontal: 10, vertical: horizontalPadding),
            itemBuilder: (context, index) {
              if (index == widget.photos.length) {
                return widget.isLoading
                    ? Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: CircularProgressIndicator(),
                      )
                    : Container(height: 0);
              }

              final photo = widget.photos[index];

              return PhotoItem(
                photo: photo,
                width: MediaQuery.of(context).size.width - horizontalPadding,
              );
            },
          );
  }
}
