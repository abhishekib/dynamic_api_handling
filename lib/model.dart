class ApiResponseHandler {
  final Map<String, dynamic> data;

  ApiResponseHandler({required this.data});

  factory ApiResponseHandler.fromJson(Map<String, dynamic> json) {
    return ApiResponseHandler(data: parseData(json));
  }

  static dynamic parseData(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value.map((key, subValue) => MapEntry(key, parseData(subValue)));
    } else if (value is List) {
      return value.map((item) => parseData(item)).toList();
    } else {
      return value; // Return primitive values as is
    }
  }
}

class CategoryResponse {
  final String country;
  final Map<String, List<Category>>? cityCategories;
  final List<Category>? standaloneCategories;

  CategoryResponse({
    required this.country,
    this.cityCategories,
    this.standaloneCategories,
  });

  factory CategoryResponse.fromJson(String country, dynamic json) {
    if (json is Map<String, dynamic>) {
      final cityCategories = json.map((key, value) {
        return MapEntry(
          key,
          (value as List<dynamic>? ?? [])
              .map((item) => Category.fromJson(item))
              .toList(),
        );
      });
      return CategoryResponse(country: country, cityCategories: cityCategories);
    } else if (json is List<dynamic>) {
      final categories = json.map((item) => Category.fromJson(item)).toList();
      return CategoryResponse(
          country: country, standaloneCategories: categories);
    } else {
      throw Exception('Unexpected data format');
    }
  }
}

class Category {
  final String category;
  final int id;
  final String title;
  final String isFav;
  final List<ContentData> contentData;

  Category({
    required this.category,
    required this.id,
    required this.title,
    required this.isFav,
    required this.contentData,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      category: json['cat'] ?? '',
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      isFav: json['isfav'] ?? 'No',
      contentData: (json['cdata'] as List<dynamic>? ?? [])
          .map((data) => ContentData.fromJson(data))
          .toList(),
    );
  }
}

class ContentData {
  final String type;
  final String audiourl;
  final List<Lyrics> lyrics;

  ContentData({
    required this.type,
    required this.audiourl,
    required this.lyrics,
  });

  factory ContentData.fromJson(Map<String, dynamic> json) {
    return ContentData(
      type: json['type'] ?? '',
      audiourl: json['audiourl'] ?? '',
      lyrics: (json['lyrics'] as List<dynamic>? ?? [])
          .map((data) => Lyrics.fromJson(data))
          .toList(),
    );
  }
}

class Lyrics {
  final String time;
  final String arabic;
  final String transliteration;
  final String translation;

  Lyrics({
    required this.time,
    required this.arabic,
    required this.transliteration,
    required this.translation,
  });

  factory Lyrics.fromJson(Map<String, dynamic> json) {
    return Lyrics(
      time: json['time'] ?? '',
      arabic: json['arabic'] ?? '',
      transliteration: json['translitration'] ?? '',
      translation: json['translation'] ?? '',
    );
  }
}
