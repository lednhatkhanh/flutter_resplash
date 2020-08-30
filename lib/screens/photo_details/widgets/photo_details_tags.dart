import 'package:flutter/material.dart';
import 'package:re_splash/models/photo.model.dart';

class PhotoDetailsTags extends StatelessWidget {
  final Photo _photo;

  PhotoDetailsTags({@required Photo photo}) : _photo = photo;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _photo.tags
            .map(
              (e) => Container(
                margin: EdgeInsets.only(right: 10),
                child: Chip(label: Text(e.title)),
              ),
            )
            .toList(),
      ),
    );
  }
}
