class User {
  final int id;
  final String name;
  final String email;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        emailVerifiedAt: json['email_verified_at'] != null
            ? DateTime.parse(json['email_verified_at'])
            : null,
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );
}

// recipe_model.dart
class Recipe {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String cookingMethod;
  final String ingredients;
  final String photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? likesCount;
  final int? commentsCount;
  final User? user;

  Recipe({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.cookingMethod,
    required this.ingredients,
    required this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    this.likesCount,
    this.commentsCount,
    this.user,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'],
        userId: json['user_id'],
        title: json['title'],
        description: json['description'],
        cookingMethod: json['cooking_method'],
        ingredients: json['ingredients'],
        photoUrl: json['photo_url'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        likesCount: json['likes_count'] ?? 0,
        commentsCount: json['comments_count'] ?? 0,
        user: json['user'] != null ? User.fromJson(json['user']) : null,
      );
}

// paginated_response.dart
class PaginatedResponse<T> {
  final int currentPage;
  final List<T> data;
  final String firstPageUrl;
  final int from;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;

  PaginatedResponse({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) =>
      PaginatedResponse<T>(
        currentPage: json['current_page'],
        data: (json['data'] as List).map((e) => fromJson(e)).toList(),
        firstPageUrl: json['first_page_url'],
        from: json['from'],
        nextPageUrl: json['next_page_url'],
        path: json['path'],
        perPage: json['per_page'],
        prevPageUrl: json['prev_page_url'],
        to: json['to'],
      );
}
