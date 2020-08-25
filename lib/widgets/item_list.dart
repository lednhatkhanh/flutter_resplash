import 'package:flutter/material.dart';

class ItemList<T> extends StatefulWidget {
  final List<T> items;
  final void Function() loadMore;
  final bool canLoadMore;
  final bool isLoading;
  final Widget Function({double width, T item}) renderItem;

  ItemList({
    @required this.items,
    @required this.loadMore,
    this.canLoadMore = true,
    @required this.isLoading,
    @required this.renderItem,
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
        widget.items.length > 0 &&
        !widget.isLoading) {
      widget.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = 15;

    return widget.isLoading && widget.items.length == 0
        ? Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            controller: _controller,
            itemCount: widget.items.length + 1,
            padding: EdgeInsets.symmetric(
                horizontal: 10, vertical: horizontalPadding),
            itemBuilder: (context, index) {
              if (index == widget.items.length) {
                return widget.isLoading
                    ? Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: CircularProgressIndicator(),
                      )
                    : Container(height: 0);
              }

              final item = widget.items[index];
              return widget.renderItem(
                item: item,
                width: MediaQuery.of(context).size.width - horizontalPadding,
              );
            },
          );
  }
}
