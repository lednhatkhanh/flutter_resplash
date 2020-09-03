import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_splash/data/photos.data.dart';
import 'package:re_splash/screens/search/providers/search_photos.provider.dart';
import 'search_photos_filter_modal.dart';

class SearchPhotosFilterButton extends StatefulWidget {
  @override
  _SearchPhotosFilterButtonState createState() =>
      _SearchPhotosFilterButtonState();
}

class _SearchPhotosFilterButtonState extends State<SearchPhotosFilterButton> {
  SearchPhotosProvider _searchPhotosProvider;

  @override
  void initState() {
    super.initState();

    _searchPhotosProvider =
        Provider.of<SearchPhotosProvider>(context, listen: false);
  }

  void _handleApplyFilter({
    @required SearchPhotosOrderBy orderBy,
    @required SearchPhotosContentFilter contentFilter,
    @required SearchPhotosColor color,
    @required SearchPhotosOrientation orientation,
  }) {
    _searchPhotosProvider.applyFilter(
      orderBy: orderBy,
      contentFilter: contentFilter,
      color: color,
      orientation: orientation,
    );
    Navigator.pop(context);
  }

  void _showFilterPhotosBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SearchPhotosFilterModal(
        onApply: _handleApplyFilter,
        initialColor: _searchPhotosProvider.color,
        initialContentFilter: _searchPhotosProvider.contentFilter,
        initialOrderBy: _searchPhotosProvider.orderBy,
        initialOrientation: _searchPhotosProvider.orientation,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: _showFilterPhotosBottomSheet,
      label: Text('Filter'),
      icon: Icon(Icons.filter_list),
    );
  }
}
