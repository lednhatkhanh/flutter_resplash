import 'package:flutter/material.dart';
import 'package:re_splash/models/photo.model.dart';
import 'photo_details_item.dart';

class PhotoDetailsExif extends StatelessWidget {
  final Photo _photo;

  PhotoDetailsExif({@required Photo photo}) : _photo = photo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PhotoDetailsItem(
                label: 'Camera',
                content: _photo.exif.model,
              ),
              SizedBox(
                height: 10,
              ),
              PhotoDetailsItem(
                label: 'Focal Length',
                content: _photo.exif.focalLength,
              ),
              SizedBox(
                height: 10,
              ),
              PhotoDetailsItem(
                label: 'ISO',
                content: _photo.exif.iso?.toString(),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PhotoDetailsItem(
                label: 'Aperture',
                content: _photo.exif.aperture,
              ),
              SizedBox(
                height: 10,
              ),
              PhotoDetailsItem(
                label: 'Shutter Speed',
                content: '${_photo.exif.exposureTime}s',
              ),
              SizedBox(
                height: 10,
              ),
              PhotoDetailsItem(
                label: 'Dimensions',
                content: '${_photo.width} x ${_photo.height}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
