import 'dart:ui';
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

  String _getImageUrl(double devicePixelRatio) {
    return Uri.parse(_coverPhoto.urls.raw).replace(
      queryParameters: {
        'dpr': devicePixelRatio.round().toString(),
        'fm': 'jpg',
        'q': '80',
        'w': _width.round().toString(),
        'h': _coverPhotoHeight.round().toString()
      },
    ).toString();
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
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final imageUrl = _getImageUrl(devicePixelRatio);

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
                    Colors.black.withOpacity(0.3),
                    BlendMode.darken,
                  ),
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    width: _width.roundToDouble(),
                    height: _coverPhotoHeight.roundToDouble(),
                    placeholder: AssetImage('assets/images/placeholder.jpg'),
                    image: NetworkImage(imageUrl),
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
