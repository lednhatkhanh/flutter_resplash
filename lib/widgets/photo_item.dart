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

  String _getImageUrl(double devicePixelRatio) {
    return Uri.parse(_photo.urls.raw).replace(
      queryParameters: {
        'dpr': devicePixelRatio.round().toString(),
        'fm': 'jpg',
        'q': '80',
        'w': _width.round().toString(),
        'h': _height.round().toString()
      },
    ).toString();
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
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final imageUrl = _getImageUrl(devicePixelRatio);

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
            child: FadeInImage(
              fit: BoxFit.cover,
              width: _width.roundToDouble(),
              height: _height.roundToDouble(),
              placeholder: AssetImage('assets/images/placeholder.jpg'),
              image: NetworkImage(imageUrl),
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
