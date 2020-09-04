import 'package:flutter/material.dart';

const double imageSize = 35;

class UserAvatarItem extends StatelessWidget {
  final void Function() onTap;
  final String image;
  final String name;

  const UserAvatarItem({
    Key key,
    @required this.image,
    @required this.name,
    this.onTap,
  }) : super(key: key);

  String _getCalculatedImage(double devicePixelRatio) {
    final parsedProfileImageUrl = Uri.parse(image);

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

    return GestureDetector(
      onTap: onTap,
      child: Row(
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
          const SizedBox(width: 10),
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
