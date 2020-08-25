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
    );
  }
}
