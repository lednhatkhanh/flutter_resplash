import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:re_splash/models/photo.model.dart';
import 'package:re_splash/widgets/user_avatar_item.dart';

class PhotoDetailsHeader extends StatefulWidget {
  final Photo _photo;
  final void Function() _onDownload;

  PhotoDetailsHeader(
      {@required Photo photo, @required void Function() onDownload})
      : _photo = photo,
        _onDownload = onDownload;

  @override
  _PhotoDetailsHeaderState createState() => _PhotoDetailsHeaderState();
}

class _PhotoDetailsHeaderState extends State<PhotoDetailsHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: UserAvatarItem(
              image: widget._photo.user.profileImage.medium,
              name: widget._photo.user.name,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: widget._onDownload,
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
