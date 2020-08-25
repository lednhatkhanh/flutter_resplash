import 'package:flutter/material.dart';
import 'package:re_splash/services/photos.service.dart';

class OrderByModalContent extends StatelessWidget {
  final void Function(GetPhotosOrderBy) onChanged;
  final GetPhotosOrderBy orderBy;

  OrderByModalContent({this.onChanged, this.orderBy});

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
              value: GetPhotosOrderBy.latest,
              groupValue: orderBy,
              onChanged: onChanged,
            ),
            title: Text('Latest'),
          ),
          ListTile(
            leading: Radio(
              value: GetPhotosOrderBy.popular,
              groupValue: orderBy,
              onChanged: onChanged,
            ),
            title: Text('Popular'),
          ),
          ListTile(
            leading: Radio(
              value: GetPhotosOrderBy.oldest,
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
