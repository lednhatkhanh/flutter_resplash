import 'package:flutter/material.dart';

import 'package:re_splash/data/photos.data.dart';
import 'package:re_splash/models/photo.model.dart';

const int PER_PAGE = 15;

class PhotoDetailsProvider extends ChangeNotifier {
  final PhotosData _photosData = PhotosData();

  Photo _photo;
  bool _isLoading;

  PhotoDetailsProvider({@required Photo photo})
      : _photo = photo,
        _isLoading = false {
    _getAPhoto();
  }

  Photo get photo {
    return _photo;
  }

  bool get isLoading {
    return _isLoading;
  }

  Future<void> _getAPhoto() async {
    try {
      _isLoading = true;
      notifyListeners();

      final photoDetails = await _photosData.getAPhoto(
        id: _photo.id,
      );

      _photo = photoDetails;
      _isLoading = false;
      notifyListeners();
    } catch (_) {}
  }
}
