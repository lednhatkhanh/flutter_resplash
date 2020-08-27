import 'package:flutter/material.dart';
import 'package:re_splash/data/collections.data.dart';

typedef OnChanged = void Function(CollectionsType);

class CollectionTypeModal extends StatelessWidget {
  final OnChanged _onChanged;
  final CollectionsType _type;

  CollectionTypeModal({
    @required OnChanged onChanged,
    @required CollectionsType type,
  })  : _onChanged = onChanged,
        _type = type;

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
              groupValue: _type,
              onChanged: _onChanged,
            ),
            title: Text('All'),
          ),
          ListTile(
            leading: Radio(
              value: CollectionsType.featured,
              groupValue: _type,
              onChanged: _onChanged,
            ),
            title: Text('Featured'),
          ),
        ],
      ),
    );
  }
}
