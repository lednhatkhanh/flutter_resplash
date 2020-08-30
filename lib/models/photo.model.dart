import 'inline_user.model.dart';

class Photo {
  final String id;
  final int width;
  final int height;
  final String color;
  final int likes;
  final bool likedByUser;
  final String description;
  final _Urls urls;
  final _Links links;
  final InlineUser user;
  final String altDescription;
  final int views;
  final int downloads;
  final _Exif exif;
  final List<_Tag> tags;

  Photo({
    this.id,
    this.width,
    this.height,
    this.color,
    this.likes,
    this.likedByUser,
    this.description,
    this.urls,
    this.links,
    this.user,
    this.altDescription,
    this.exif,
    this.views,
    this.downloads,
    this.tags,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      width: json['width'],
      height: json['height'],
      color: json['color'],
      likes: json['likes'],
      views: json['views'],
      downloads: json['downloads'],
      description: json['description'],
      likedByUser: json['liked_by_user'],
      altDescription: json['alt_description'],
      urls: _Urls.fromJson(json['urls']),
      links: _Links.fromJson(json['links']),
      user: InlineUser.fromJson(json['user']),
      exif: json['exif'] != null ? _Exif.fromJson(json['exif']) : null,
      tags: json['tags'] != null
          ? (json['tags'] as List<dynamic>)
              .map((e) => _Tag.fromJson(e))
              .toList()
          : null,
    );
  }
}

class _Urls {
  final String raw;
  final String full;
  final String regular;
  final String small;
  final String thumb;

  _Urls({
    this.raw,
    this.full,
    this.regular,
    this.small,
    this.thumb,
  });

  factory _Urls.fromJson(Map<String, dynamic> json) {
    return _Urls(
      raw: json['raw'],
      full: json['full'],
      regular: json['regular'],
      small: json['small'],
      thumb: json['thumb'],
    );
  }
}

class _Links {
  final String self;
  final String html;
  final String download;
  final String downloadLocation;

  _Links({
    this.self,
    this.html,
    this.download,
    this.downloadLocation,
  });

  factory _Links.fromJson(Map<String, dynamic> json) {
    return _Links(
      self: json['self'],
      html: json['html'],
      download: json['download'],
      downloadLocation: json['download_location'],
    );
  }
}

class _Exif {
  final String make;
  final String model;
  final String exposureTime;
  final String aperture;
  final String focalLength;
  final int iso;

  _Exif({
    this.make,
    this.model,
    this.exposureTime,
    this.aperture,
    this.focalLength,
    this.iso,
  });

  factory _Exif.fromJson(Map<String, dynamic> json) {
    return _Exif(
      make: json['make'],
      model: json['model'],
      exposureTime: json['exposure_time'],
      aperture: json['aperture'],
      focalLength: json['focal_length'],
      iso: json['iso'],
    );
  }
}

class _Tag {
  final String title;

  _Tag({
    this.title,
  });

  factory _Tag.fromJson(Map<String, dynamic> json) {
    return _Tag(title: json['title']);
  }
}
