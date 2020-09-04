import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:re_splash/models/photo.model.dart';
import 'package:re_splash/screens/photo_details/photo_details.screen.dart';
import 'package:re_splash/screens/user_details/user_details.screen.dart';
import 'package:re_splash/widgets/user_avatar_item.dart';

class PhotoItem extends StatelessWidget {
  final Photo photo;
  final double width;

  PhotoItem({@required this.photo, @required this.width});

  double get _ratio {
    return photo.width / photo.height;
  }

  double get _height {
    return width / _ratio;
  }

  void _goToPhotoDetailsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoDetailsScreen(photo: photo),
      ),
    );
  }

  void _goToUserDetailsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsScreen(user: photo.user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserAvatarItem(
          image: photo.user.profileImage.medium,
          name: photo.user.name,
          onTap: () => _goToUserDetailsScreen(context),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _goToPhotoDetailsScreen(context),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              width: width.roundToDouble(),
              height: _height.roundToDouble(),
              imageUrl: photo.urls.regular,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
