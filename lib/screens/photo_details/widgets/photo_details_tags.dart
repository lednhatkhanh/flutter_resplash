import 'package:flutter/material.dart';
import 'package:re_splash/models/photo.model.dart';
import 'package:re_splash/screens/search/search.screen.dart';

class PhotoDetailsTags extends StatelessWidget {
  final Photo _photo;

  PhotoDetailsTags({@required Photo photo}) : _photo = photo;

  void _goToSearchScreen(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen(query: title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _photo.tags
            .map(
              (tagItem) => Container(
                margin: EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => _goToSearchScreen(context, tagItem.title),
                  child: Chip(label: Text(tagItem.title)),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
