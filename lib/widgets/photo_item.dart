import 'package:flutter/material.dart';
import 'package:re_splash/models/photo.model.dart';

class PhotoItem extends StatelessWidget {
  final Photo photo;
  final double width;
  final double _profileImageSize = 35;

  PhotoItem({@required this.photo, @required this.width});

  double get _ratio {
    return photo.width / photo.height;
  }

  double get _height {
    return width / _ratio;
  }

  String _getImageUrl(double devicePixelRatio) {
    return Uri.parse(photo.urls.raw).replace(
      queryParameters: {
        'dpr': devicePixelRatio.round().toString(),
        'fm': 'jpg',
        'q': '80',
        'w': width.round().toString(),
        'h': _height.round().toString()
      },
    ).toString();
  }

  String _getProfileImageUrl(double devicePixelRatio) {
    final parsedProfileImageUrl = Uri.parse(photo.user.profileImage.medium);

    return parsedProfileImageUrl.replace(
      queryParameters: {
        ...parsedProfileImageUrl.queryParameters,
        'dpr': devicePixelRatio.round().toString(),
        'w': _profileImageSize.round().toString(),
        'h': _profileImageSize.round().toString()
      },
    ).toString();
  }

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final imageUrl = _getImageUrl(devicePixelRatio);
    final profileImageUrl = _getProfileImageUrl(devicePixelRatio);

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: _profileImageSize,
              height: _profileImageSize,
              child: CircleAvatar(
                backgroundImage: NetworkImage(profileImageUrl),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              photo.user.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FadeInImage(
            fit: BoxFit.cover,
            width: width.roundToDouble(),
            height: _height.roundToDouble(),
            placeholder: AssetImage('assets/images/placeholder.jpg'),
            image: NetworkImage(imageUrl),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
