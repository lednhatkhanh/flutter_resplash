import 'package:flutter/material.dart';
import 'package:re_splash/services/collections.service.dart';

class CollectionTypeModal extends StatelessWidget {
  final void Function(CollectionsType) onChanged;
  final CollectionsType type;

  CollectionTypeModal({@required this.onChanged, @required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(10),
            child: Text(
              'Types',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          ListTile(
            leading: Radio(
              value: CollectionsType.all,
              groupValue: type,
              onChanged: onChanged,
            ),
            title: Text('All'),
          ),
          ListTile(
            leading: Radio(
              value: CollectionsType.featured,
              groupValue: type,
              onChanged: onChanged,
            ),
            title: Text('Featured'),
          ),
        ],
      ),
    );
  }
}
