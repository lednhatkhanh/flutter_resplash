import 'package:flutter/material.dart';
import 'package:re_splash/models/collection.model.dart';
import 'package:re_splash/models/photo.model.dart';
import 'package:re_splash/widgets/collection_item.dart';
import 'package:re_splash/widgets/photo_item.dart';

Widget _renderDefaultItem<T>({@required T item, double width}) => T == Photo
    ? PhotoItem(photo: item as Photo, width: width)
    : CollectionItem(
        collection: item as Collection,
        width: width,
      );

class ItemList<T> extends StatefulWidget {
  final List<T> items;
  final void Function() loadMore;
  final bool canLoadMore;
  final bool isLoading;
  final Widget Function({double width, T item}) renderItem;
  final Widget header;
  final Widget empty;

  ItemList({
    @required this.items,
    @required this.loadMore,
    @required this.isLoading,
    this.renderItem,
    this.canLoadMore = true,
    this.header,
    this.empty,
  });

  @override
  _ItemListState<T> createState() => _ItemListState<T>();
}

class _ItemListState<T> extends State<ItemList<T>> {
  final ScrollController _controller =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  @override
  void initState() {
    super.initState();

    _controller.addListener(_handleTriggerLoadmore);
  }

  int get _itemCount {
    return widget.items.length + (widget.header != null ? 2 : 1);
  }

  @override
  void dispose() {
    super.dispose();

    _controller.removeListener(_handleTriggerLoadmore);
    _controller.dispose();
  }

  void _handleTriggerLoadmore() {
    final isEnd =
        _controller.offset >= _controller.position.maxScrollExtent * 0.8;
    if (isEnd &&
        widget.canLoadMore &&
        widget.items.isNotEmpty &&
        !widget.isLoading) {
      widget.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = 15.0;

    if (widget.isLoading && _itemCount == 0) {
      return Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
    }

    if (widget.items.isEmpty && widget.empty != null) {
      return widget.empty;
    }

    return ListView.builder(
      controller: _controller,
      itemCount: _itemCount,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: horizontalPadding,
      ),
      itemBuilder: (context, index) {
        // Render header if available
        if (index == 0 && widget.header != null) {
          return widget.header;
        }

        final itemIndex = widget.header != null ? index - 1 : index;
        if (itemIndex == widget.items.length) {
          return widget.isLoading
              ? Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: CircularProgressIndicator(),
                )
              : Container(height: 0);
        }

        if (T == Photo || T == Collection) {
          return _renderDefaultItem<T>(
            item: widget.items[index],
            width: MediaQuery.of(context).size.width - horizontalPadding,
          );
        }

        return widget.renderItem(
          item: widget.items[itemIndex],
          width: MediaQuery.of(context).size.width - horizontalPadding,
        );
      },
    );
  }
}
