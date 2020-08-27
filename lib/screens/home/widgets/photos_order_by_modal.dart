import 'package:flutter/material.dart';
import 'package:re_splash/data/photos.data.dart';

typedef OnChange = void Function(PhotosOrderBy);

class PhotosOrderByModal extends StatelessWidget {
  final OnChange _onChanged;
  final PhotosOrderBy _orderBy;

  PhotosOrderByModal({
    @required OnChange onChanged,
    @required PhotosOrderBy orderBy,
  })  : _onChanged = onChanged,
        _orderBy = orderBy;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(10),
            child: Text(
              'Order by',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          ListTile(
            leading: Radio(
              value: PhotosOrderBy.latest,
              groupValue: _orderBy,
              onChanged: _onChanged,
            ),
            title: Text('Latest'),
          ),
          ListTile(
            leading: Radio(
              value: PhotosOrderBy.popular,
              groupValue: _orderBy,
              onChanged: _onChanged,
            ),
            title: Text('Popular'),
          ),
          ListTile(
            leading: Radio(
              value: PhotosOrderBy.oldest,
              groupValue: _orderBy,
              onChanged: _onChanged,
            ),
            title: Text('Oldest'),
          ),
        ],
      ),
    );
  }
}
