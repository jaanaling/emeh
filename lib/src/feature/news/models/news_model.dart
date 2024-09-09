

import 'package:test_app/src/core/utils/log.dart';

class News {
  final String title;
  final String description;
  final String content;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String source;

  News({
    required this.title,
    required this.description,
    required this.content,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.source,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    try {
      // Получаем контент и очищаем его
      String content = json['content'] as String? ?? '';
      content = _cleanContent(content);

      return News(
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        content: _truncateContent(content, maxLength: 200),
        url: json['url'] as String? ?? '',
        urlToImage: json['urlToImage'] as String? ??
            'https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty-300x240.jpg',
        publishedAt:
            _formatDate(json['publishedAt'] as String? ?? '1970-01-01'),
        source: json['source'] is String
            ? json['source'] as String
            : (json['source'] as Map<String, dynamic>)['name'] as String? ?? '',
      );
    } catch (e) {
      logger.e('Failed to parse JSON item: $e');
      rethrow; // Пробрасываем исключение для дальнейшей обработки
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'content': content,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'source': source is Map<String, dynamic> ? source : {'name': source},
    };
  }

  factory News.fromMap(Map<String, dynamic> map) {
    // Получаем значения из карты с проверкой типа и значением по умолчанию
    String content = (map['content'] as String?) ?? '';
    content = _cleanContent(content);

    return News(
      title: (map['title'] as String?) ?? '',
      description: (map['description'] as String?) ?? '',
      content: _truncateContent(content, maxLength: 200),
      url: (map['url'] as String?) ?? '',
      urlToImage: (map['urlToImage'] as String?) ??
          'https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty-300x240.jpg',
      publishedAt: _formatDate((map['publishedAt'] as String?) ?? '1970-01-01'),
      source: (map['source'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'source': source is Map<String, dynamic> ? source : {'name': source},
    };
  }

  // Метод для форматирования даты
  static String _formatDate(String dateTime) {
    try {
      final DateTime parsedDate = DateTime.parse(dateTime);
      return '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
    } catch (e) {
      // Возвращаем дефолтную дату при ошибке парсинга
      return '1970-01-01';
    }
  }

  static String _truncateContent(String content, {int maxLength = 100}) {
    if (content.length > maxLength) {
      return '${content.substring(0, maxLength)}...';
    } else {
      return content;
    }
  }

  // Удаляет часть текста после "… [+xxx chars]"
  static String _cleanContent(String content) {
    final regex = RegExp(r'\s\[\+.*chars\]');
    return content.replaceAll(regex, '');
  }

  @override
  bool operator ==(covariant News other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.description == description &&
        other.content == content &&
        other.url == url &&
        other.urlToImage == urlToImage &&
        other.publishedAt == publishedAt &&
        other.source == source;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        description.hashCode ^
        content.hashCode ^
        url.hashCode ^
        urlToImage.hashCode ^
        publishedAt.hashCode ^
        source.hashCode;
  }
}
