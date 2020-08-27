import 'package:flutter/material.dart';
import 'package:re_splash/data/photos.data.dart';

class PhotosOrderByModal extends StatelessWidget {
  final void Function(PhotosOrderBy) onChanged;
  final PhotosOrderBy orderBy;

  PhotosOrderByModal({@required this.onChanged, @required this.orderBy});

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
              groupValue: orderBy,
              onChanged: onChanged,
            ),
            title: Text('Latest'),
          ),
          ListTile(
            leading: Radio(
              value: PhotosOrderBy.popular,
              groupValue: orderBy,
              onChanged: onChanged,
            ),
            title: Text('Popular'),
          ),
          ListTile(
            leading: Radio(
              value: PhotosOrderBy.oldest,
              groupValue: orderBy,
              onChanged: onChanged,
            ),
            title: Text('Oldest'),
          ),
        ],
      ),
    );
  }
}
