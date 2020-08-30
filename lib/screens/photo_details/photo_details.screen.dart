import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_splash/models/photo.model.dart';
import 'package:re_splash/screens/photo_details/providers/photo_details.provider.dart';
import 'package:re_splash/screens/photo_details/widgets/photo_details_content.dart';

class PhotoDetailsScreen extends StatelessWidget {
  final Photo _photo;

  PhotoDetailsScreen({@required Photo photo}) : _photo = photo;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PhotoDetailsProvider(photo: _photo),
      child: PhotoDetailsContent(photo: _photo),
    );
  }
}
