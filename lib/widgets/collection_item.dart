import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:re_splash/models/collection.model.dart';
import 'package:re_splash/models/photo.model.dart';
import 'package:re_splash/screens/collection_details/collection_details.screen.dart';
import 'package:re_splash/screens/user_details/user_details.screen.dart';
import 'package:re_splash/widgets/user_avatar_item.dart';

class CollectionItem extends StatelessWidget {
  final Collection collection;
  final double width;

  CollectionItem({@required this.collection, @required this.width});

  Photo get _coverPhoto {
    return collection.coverPhoto;
  }

  double get _coverPhotoRatio {
    return _coverPhoto.width / _coverPhoto.height;
  }

  double get _coverPhotoHeight {
    return width / _coverPhotoRatio;
  }

  void _goToUserDetailsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsScreen(user: collection.user),
      ),
    );
  }

  void _goToCollectionDetailsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CollectionDetailsScreen(
          collection: collection,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            UserAvatarItem(
              onTap: () => _goToUserDetailsScreen(context),
              image: collection.user.profileImage.medium,
              name: collection.user.name,
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () => _goToCollectionDetailsScreen(context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2),
                    BlendMode.darken,
                  ),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: width.roundToDouble(),
                    height: _coverPhotoHeight.roundToDouble(),
                    imageUrl: collection.coverPhoto.urls.regular,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(bottom: 10, left: 20, top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  collection.title,
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '${collection.totalPhotos} photos',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
