import 'package:flutter/material.dart';
import 'package:re_splash/data/photos.data.dart';
import 'filter_photo_item_data.dart';

const sortByItemData = [
  FilterPhotoItemData(value: SearchPhotosOrderBy.relevant, text: 'RELEVANCE'),
  FilterPhotoItemData(value: SearchPhotosOrderBy.latest, text: 'LATEST'),
];
const contentFilterItemData = [
  FilterPhotoItemData(value: SearchPhotosContentFilter.low, text: 'LOW'),
  FilterPhotoItemData(value: SearchPhotosContentFilter.high, text: 'HIGH'),
];
const orientationItemData = [
  FilterPhotoItemData(value: SearchPhotosOrientation.any, text: 'ANY'),
  FilterPhotoItemData(
    value: SearchPhotosOrientation.landscape,
    icon: Icons.crop_landscape,
  ),
  FilterPhotoItemData(
    value: SearchPhotosOrientation.portrait,
    icon: Icons.crop_portrait,
  ),
  FilterPhotoItemData(
    value: SearchPhotosOrientation.squarish,
    icon: Icons.crop_square,
  ),
];
const colorItemData = [
  FilterPhotoItemData(value: SearchPhotosColor.any, text: 'Any'),
  FilterPhotoItemData(
      value: SearchPhotosColor.black_and_white, text: 'Black and white'),
  FilterPhotoItemData(value: SearchPhotosColor.black, text: 'Black'),
  FilterPhotoItemData(value: SearchPhotosColor.white, text: 'White'),
  FilterPhotoItemData(value: SearchPhotosColor.yellow, text: 'Yellow'),
  FilterPhotoItemData(value: SearchPhotosColor.orange, text: 'Orange'),
  FilterPhotoItemData(value: SearchPhotosColor.red, text: 'Red'),
  FilterPhotoItemData(value: SearchPhotosColor.purple, text: 'Purple'),
  FilterPhotoItemData(value: SearchPhotosColor.magenta, text: 'Magenta'),
  FilterPhotoItemData(value: SearchPhotosColor.green, text: 'Green'),
  FilterPhotoItemData(value: SearchPhotosColor.teal, text: 'Teal'),
  FilterPhotoItemData(value: SearchPhotosColor.blue, text: 'Blue'),
];

class SearchPhotosFilterModal extends StatefulWidget {
  final void Function({
    @required SearchPhotosOrderBy orderBy,
    @required SearchPhotosContentFilter contentFilter,
    @required SearchPhotosColor color,
    @required SearchPhotosOrientation orientation,
  }) onApply;
  final SearchPhotosOrderBy initialOrderBy;
  final SearchPhotosContentFilter initialContentFilter;
  final SearchPhotosOrientation initialOrientation;
  final SearchPhotosColor initialColor;

  const SearchPhotosFilterModal(
      {Key key,
      @required this.onApply,
      this.initialOrderBy,
      this.initialContentFilter,
      this.initialOrientation,
      this.initialColor})
      : super(key: key);

  @override
  _SearchPhotosFilterModalState createState() =>
      _SearchPhotosFilterModalState();
}

class _SearchPhotosFilterModalState extends State<SearchPhotosFilterModal> {
  SearchPhotosOrderBy _orderBy;
  SearchPhotosContentFilter _contentFilter;
  SearchPhotosOrientation _orientation;
  SearchPhotosColor _color;

  @override
  void initState() {
    super.initState();

    _orderBy = widget.initialOrderBy;
    _contentFilter = widget.initialContentFilter;
    _orientation = widget.initialOrientation;
    _color = widget.initialColor;
  }

  void _handleChangeSortBy(SearchPhotosOrderBy value) {
    setState(() {
      _orderBy = value;
    });
  }

  void _handleChangeContentFilter(SearchPhotosContentFilter value) {
    setState(() {
      _contentFilter = value;
    });
  }

  void _handleChangeOrientation(SearchPhotosOrientation value) {
    setState(() {
      _orientation = value;
    });
  }

  void _handleChangecolor(SearchPhotosColor value) {
    setState(() {
      _color = value;
    });
  }

  void _handleApplyButtonClicked() {
    widget.onApply(
      color: _color,
      contentFilter: _contentFilter,
      orderBy: _orderBy,
      orientation: _orientation,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 440,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilterPhotoItem<SearchPhotosOrderBy>(
            label: 'Sort By',
            value: _orderBy,
            onChange: _handleChangeSortBy,
            items: sortByItemData,
          ),
          SizedBox(height: 15),
          FilterPhotoItem<SearchPhotosContentFilter>(
            label: 'Content Filter',
            value: _contentFilter,
            onChange: _handleChangeContentFilter,
            items: contentFilterItemData,
          ),
          SizedBox(height: 15),
          FilterPhotoItem<SearchPhotosColor>(
            label: 'Color',
            value: _color,
            onChange: _handleChangecolor,
            items: colorItemData,
            useDropdown: true,
          ),
          SizedBox(height: 15),
          FilterPhotoItem<SearchPhotosOrientation>(
            items: orientationItemData,
            label: 'Orientation',
            onChange: _handleChangeOrientation,
            value: _orientation,
          ),
          SizedBox(height: 15),
          RaisedButton(
            color: Colors.deepPurple,
            onPressed: _handleApplyButtonClicked,
            child: Text(
              'APPLY',
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
