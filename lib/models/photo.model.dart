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
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      width: json['width'],
      height: json['height'],
      color: json['color'],
      likes: json['likes'],
      description: json['description'],
      likedByUser: json['liked_by_user'],
      altDescription: json['alt_description'],
      urls: _Urls.fromJson(json['urls']),
      links: _Links.fromJson(json['links']),
      user: InlineUser.fromJson(json['user']),
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
