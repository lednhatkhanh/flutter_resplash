import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:re_splash/models/collection.model.dart';
import 'package:re_splash/models/photo.model.dart';
import 'package:re_splash/routes/collection/collection_details.dart';

class CollectionItem extends StatelessWidget {
  final Collection collection;
  final double width;
  final double _profileImageSize = 35;

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

  String _getImageUrl(double devicePixelRatio) {
    return Uri.parse(_coverPhoto.urls.raw).replace(
      queryParameters: {
        'dpr': devicePixelRatio.round().toString(),
        'fm': 'jpg',
        'q': '80',
        'w': width.round().toString(),
        'h': _coverPhotoHeight.round().toString()
      },
    ).toString();
  }

  String _getProfileImageUrl(double devicePixelRatio) {
    final Uri parsedProfileImageUrl =
        Uri.parse(collection.user.profileImage.medium);

    return parsedProfileImageUrl.replace(
      queryParameters: {
        ...parsedProfileImageUrl.queryParameters,
        'dpr': devicePixelRatio.round().toString(),
        'w': _profileImageSize.round().toString(),
        'h': _profileImageSize.round().toString()
      },
    ).toString();
  }

  void _goToCollectionDetailsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CollectionDetails(
                collection: this.collection,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final String imageUrl = _getImageUrl(devicePixelRatio);
    final String profileImageUrl = _getProfileImageUrl(devicePixelRatio);

    return GestureDetector(
      onTap: () => _goToCollectionDetailsScreen(context),
      child: Stack(
        children: [
          Column(
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
                    collection.user.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: new BorderRadius.circular(10),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3),
                    BlendMode.darken,
                  ),
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    width: width.roundToDouble(),
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
      ),
    );
  }
}
