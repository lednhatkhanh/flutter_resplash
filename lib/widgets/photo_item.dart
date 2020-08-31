import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:re_splash/models/photo.model.dart';
import 'package:re_splash/screens/photo_details/photo_details.screen.dart';
import 'package:re_splash/widgets/user_avatar_item.dart';

class PhotoItem extends StatelessWidget {
  final Photo _photo;
  final double _width;

  PhotoItem({@required Photo photo, @required double width})
      : _photo = photo,
        _width = width;

  double get _ratio {
    return _photo.width / _photo.height;
  }

  double get _height {
    return _width / _ratio;
  }

  void _goToPhotoDetailsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoDetailsScreen(photo: _photo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _goToPhotoDetailsScreen(context),
      child: Column(
        children: [
          UserAvatarItem(
            image: _photo.user.profileImage.medium,
            name: _photo.user.name,
          ),
          const SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              width: _width.roundToDouble(),
              height: _height.roundToDouble(),
              imageUrl: _photo.urls.regular,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
