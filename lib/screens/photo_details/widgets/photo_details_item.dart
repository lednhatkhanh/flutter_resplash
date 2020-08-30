import 'package:flutter/material.dart';

class PhotoDetailsItem extends StatelessWidget {
  final String _label;
  final String _content;

  PhotoDetailsItem({@required String label, String content})
      : _label = label,
        _content = content;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _label,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 6),
          Text(
            _content ?? 'Unknown',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
    );
  }
}
