import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:re_splash/models/photo.model.dart';
import 'package:re_splash/screens/photo_details/widgets/photo_details_item.dart';

class PhotoDetailsStatics extends StatelessWidget {
  final Photo _photo;

  PhotoDetailsStatics({@required Photo photo}) : _photo = photo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          PhotoDetailsItem(
            label: 'Views',
            content: NumberFormat.compact().format(_photo.views),
          ),
          PhotoDetailsItem(
            label: 'Downloads',
            content: NumberFormat.compact().format(_photo.downloads),
          ),
          PhotoDetailsItem(
            label: 'Likes',
            content: NumberFormat.compact().format(_photo.likes),
          ),
        ],
      ),
    );
  }
}
