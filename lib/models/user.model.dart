class User {
  final String id;
  final String username;
  final String name;
  final _Links links;
  final _ProfileImage profileImage;
  final int totalLikes;
  final int totalPhotos;
  final int totalCollections;
  final String location;
  final String bio;
  final String portfolioUrl;

  User({
    this.totalLikes,
    this.totalPhotos,
    this.totalCollections,
    this.id,
    this.username,
    this.name,
    this.links,
    this.profileImage,
    this.location,
    this.bio,
    this.portfolioUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      links: _Links.fromJson(json['links']),
      profileImage: _ProfileImage.fromJson(json['profile_image']),
      totalLikes: json['total_likes'],
      totalPhotos: json['total_photos'],
      totalCollections: json['total_collections'],
      location: json['location'],
      bio: json['bio'],
      portfolioUrl: json['portfolio_url'],
    );
  }
}

class _Links {
  final String self;
  final String html;
  final String photos;
  final String likes;
  final String portfolio;

  _Links({
    this.self,
    this.html,
    this.photos,
    this.likes,
    this.portfolio,
  });

  factory _Links.fromJson(Map<String, dynamic> json) {
    return _Links(
      self: json['self'],
      html: json['html'],
      photos: json['photos'],
      likes: json['likes'],
      portfolio: json['portfolio'],
    );
  }
}

class _ProfileImage {
  final String small;
  final String medium;
  final String large;

  _ProfileImage({
    this.small,
    this.medium,
    this.large,
  });

  factory _ProfileImage.fromJson(Map<String, dynamic> json) {
    return _ProfileImage(
      small: json['small'],
      medium: json['medium'],
      large: json['large'],
    );
  }
}
