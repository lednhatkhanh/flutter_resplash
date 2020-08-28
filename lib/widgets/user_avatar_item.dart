import 'package:flutter/material.dart';

const double imageSize = 35;

class UserAvatarItem extends StatelessWidget {
  final String _image;
  final String _name;

  const UserAvatarItem({
    Key key,
    @required String image,
    @required String name,
  })  : _image = image,
        _name = name,
        super(key: key);

  String _getCalculatedImage(double devicePixelRatio) {
    final parsedProfileImageUrl = Uri.parse(_image);

    return parsedProfileImageUrl.replace(
      queryParameters: {
        ...parsedProfileImageUrl.queryParameters,
        'dpr': devicePixelRatio.round().toString(),
        'w': imageSize.round().toString(),
        'h': imageSize.round().toString()
      },
    ).toString();
  }

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Row(
      children: [
        Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(_getCalculatedImage(devicePixelRatio)),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          _name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
