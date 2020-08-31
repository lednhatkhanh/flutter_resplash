import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:re_splash/models/collection.model.dart';
import 'package:re_splash/models/photo.model.dart';
import 'package:re_splash/screens/collection_details/collection_details.screen.dart';
import 'package:re_splash/widgets/user_avatar_item.dart';

class CollectionItem extends StatelessWidget {
  final Collection _collection;
  final double _width;

  CollectionItem({@required Collection collection, @required double width})
      : _collection = collection,
        _width = width;

  Photo get _coverPhoto {
    return _collection.coverPhoto;
  }

  double get _coverPhotoRatio {
    return _coverPhoto.width / _coverPhoto.height;
  }

  double get _coverPhotoHeight {
    return _width / _coverPhotoRatio;
  }

  void _goToCollectionDetailsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CollectionDetailsScreen(
          collection: _collection,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _goToCollectionDetailsScreen(context),
      child: Stack(
        children: [
          Column(
            children: [
              UserAvatarItem(
                image: _collection.user.profileImage.medium,
                name: _collection.user.name,
              ),
              const SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2),
                    BlendMode.darken,
                  ),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: _width.roundToDouble(),
                    height: _coverPhotoHeight.roundToDouble(),
                    imageUrl: _collection.coverPhoto.urls.regular,
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
                    _collection.title,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${_collection.totalPhotos} photos',
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
      ),
    );
  }
}
