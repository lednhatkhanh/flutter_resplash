import 'inline_user.model.dart';
import 'photo.model.dart';

class Collection {
  final int id;
  final String title;
  final String description;
  final DateTime publishedAt;
  final DateTime lastCollectedAt;
  final DateTime updatedAt;
  final int totalPhotos;
  final bool private;
  final String shareKey;
  final Photo coverPhoto;
  final InlineUser user;
  final _CollectionLinks links;

  Collection({
    this.id,
    this.title,
    this.description,
    this.publishedAt,
    this.lastCollectedAt,
    this.updatedAt,
    this.totalPhotos,
    this.private,
    this.shareKey,
    this.coverPhoto,
    this.user,
    this.links,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      publishedAt: DateTime.parse(json['published_at']),
      lastCollectedAt: DateTime.parse(json['last_collected_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      totalPhotos: json['total_photos'],
      private: json['private'],
      shareKey: json['share_key'],
      coverPhoto: Photo.fromJson(json['cover_photo']),
      user: InlineUser.fromJson(json['user']),
      links: _CollectionLinks.fromJson(json['links']),
    );
  }
}

class _CollectionLinks {
  final String self;
  final String html;
  final String photos;
  final String related;

  _CollectionLinks({
    this.self,
    this.html,
    this.photos,
    this.related,
  });

  factory _CollectionLinks.fromJson(Map<String, dynamic> json) {
    return _CollectionLinks(
      self: json['self'],
      html: json['html'],
      photos: json['photos'],
      related: json['related'],
    );
  }
}
